# frozen_string_literal: true

# == Schema Information
#
# Table name: exec_commands
#
#  id          :bigint           not null, primary key
#  command     :text
#  executed_at :datetime
#  result      :json
#  separator   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#

module Shinonome
  # コマンド実行用
  class ExecCommand < ApplicationRecord
    self.table_name = :exec_commands

    BOM = "\uFEFF"

    class Error < RuntimeError
    end

    enum separator: { tab: 1, comma: 2 }

    has_one_attached :result_data if defined?(ActiveStorage)

    belongs_to :user, class_name: 'Shinonome::User'

    validates :command, presence: true

    attr_reader :csv_path

    # 失敗したらerrorを保存してfalseを返す
    def execute # rubocop:disable Metrics/CyclomaticComplexity
      Dir.mktmpdir do |tmpdir|
        path = File.join(tmpdir, 'result.zip')

        commands_result = Shinonome::ExecCommand::CommandExecutor.new.execute(self, output_dir: tmpdir)

        self.executed_at = Time.zone.now

        if commands_result.successful?
          make_zip(results, zip_dir: dir, path: path)
          self.result_data.attach(io: File.open(path), filename: "result.zip", content_type: 'application/zip')
          self.save!

          true
        else
          error_messages = commands_result.errors.map do |error|
            "#{error[:error].message}"
          end

          self.result = {success: false, messages: error_messages}
          self.save!

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
      if result && !result['success']
        result['messages']
      end
    end

    private

    def make_zip(result, zip_dir:, path:)
      Zip::ZipOutputStream.open(path) do |f|
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
