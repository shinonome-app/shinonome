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

    # 同時に複数のコマンド実行が走らないようにするためのPostgreSQL advisory lockのキー。
    # セッション切断時に自動解放されるため、プロセスがクラッシュしてもロックが残留しない。
    ADVISORY_LOCK_KEY = 8_127_364_521

    # 失敗したらerrorを保存してfalseを返す
    # uploaded_file: ファイル追加/更新コマンド用にアップロードされたファイル（ZIP可・任意）
    def execute(uploaded_file = nil)
      unless try_advisory_lock
        self.executed_at = Time.zone.now
        self.result = { success: false, messages: [I18n.t('errors.exec_command.already_running')] }
        save!
        return false
      end

      begin
        run_commands(uploaded_file)
      ensure
        release_advisory_lock
      end
    end

    def run_commands(uploaded_file)
      Dir.mktmpdir do |tmpdir|
        path = File.join(tmpdir, 'result.zip')
        outputdir = File.join(tmpdir, 'output')
        uploaddir = File.join(tmpdir, 'upload')
        Dir.mkdir(outputdir)
        Dir.mkdir(uploaddir)

        extract_uploaded_file(uploaded_file, uploaddir) if uploaded_file

        commands_result = Shinonome::ExecCommand::CommandExecutor.new.execute(self, output_dir: outputdir, upload_dir: uploaddir)

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

    private :run_commands

    private

    # コマンド実行用のadvisory lockを取得する。取得できなければfalse（他の実行が進行中）
    def try_advisory_lock
      self.class.connection.select_value("SELECT pg_try_advisory_lock(#{ADVISORY_LOCK_KEY})")
    end

    def release_advisory_lock
      self.class.connection.execute("SELECT pg_advisory_unlock(#{ADVISORY_LOCK_KEY})")
    end

    # アップロードされたファイルをupload_dirに展開する。
    # ZIPの場合は中身を（ディレクトリ階層を無視して）展開し、それ以外はそのまま配置する。
    def extract_uploaded_file(uploaded_file, dest_dir)
      original_filename = uploaded_file.respond_to?(:original_filename) ? uploaded_file.original_filename : File.basename(uploaded_file.path)

      if File.extname(original_filename).casecmp('.zip').zero?
        ::Zip::File.open(uploaded_file.path) do |zip|
          zip.each do |entry|
            next if entry.directory?

            entry.extract(File.join(dest_dir, File.basename(entry.name))) { true }
          end
        end
      else
        FileUtils.cp(uploaded_file.path, File.join(dest_dir, File.basename(original_filename)))
      end
    end

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
