# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id          :bigint           not null, primary key
#  command     :text
#  executed_at :datetime
#  result      :jsonb
#  separator   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

require 'zip'

module Shinonome
  # コマンド実行用
  class ExecCommand < ApplicationRecord
    self.table_name = :exec_commands

    BOM = "\uFEFF"

    class Error < RuntimeError
    end

    enum :separator, { tab: 1, comma: 2 }

    has_one_attached :result_data if defined?(ActiveStorage)

    belongs_to :user, class_name: 'Shinonome::User'

    def filesystem
      @filesystem ||= Shinonome::ExecCommand::Filesystem.new(self)
    end

    def file_exists?
      filesystem.exists?
    end

    def download_url
      Rails.application.routes.url_helpers.admin_exec_command_download_path(self)
    end

    validates :command, presence: true

    attr_reader :csv_path

    # 失敗したらerrorを保存してfalseを返す
    def execute
      Dir.mktmpdir do |tmpdir|
        path = File.join(tmpdir, 'result.zip')
        outputdir = File.join(tmpdir, 'output')
        Dir.mkdir(outputdir)

        commands_result = Shinonome::ExecCommand::CommandExecutor.new.execute(self, output_dir: outputdir)

        self.executed_at = Time.zone.now

        if commands_result.successful?
          make_zip(zip_dir: outputdir, path:)
          self.result = { success: true }
          save! # 先に保存してIDを確定させる

          filesystem.copy_from(path)

          true
        else
          error_messages = commands_result.errors.map do |error|
            error[:error].message
          end

          self.result = { success: false, messages: error_messages }
          save!

          false
        end
      end
    end

    def successful?
      result && result['success']
    end

    def failed?
      result && !result['success']
    end

    def error_messages
      result['messages'] if result && !result['success']
    end

    private

    def make_zip(zip_dir:, path:)
      ::Zip::OutputStream.open(path) do |f|
        Dir.chdir(zip_dir) do
          Dir.glob('**/*') do |file|
            next unless File.file? file

            logger.info("output #{file}")
            f.put_next_entry file
            f << File.read(file)
          end
        end
      end
    end
  end
end
