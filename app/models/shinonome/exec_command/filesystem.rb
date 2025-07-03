# frozen_string_literal: true

module Shinonome
  class ExecCommand < ApplicationRecord
    # ExecCommandのファイルシステム操作を担当するクラス
    class Filesystem
      include ActiveModel::Model

      attr_accessor :exec_command

      def initialize(exec_command)
        @exec_command = exec_command
      end

      # ファイルシステム上のパス
      def path
        return nil unless exec_command.persisted?

        Rails.root.join('data/exec_commands', exec_command.user_id.to_s, exec_command.id.to_s, 'result.zip')
      end

      # ファイルが存在するか
      def exists?
        return false if path.nil?

        File.exist?(path)
      end

      # ファイルをコピー
      def copy_from(source_path)
        return false if path.nil?

        ensure_directory
        FileUtils.cp(source_path, path)
        true
      end

      # IOオブジェクトからファイルシステムに保存
      def save(io)
        return false if path.nil?

        ensure_directory
        File.binwrite(path, io.read)
        true
      end

      # ファイルシステムからファイル内容を読み込み
      def read
        return nil if path.nil? || !exists?

        File.read(path, mode: 'rb')
      end

      # ファイルシステムからファイルを削除
      def delete
        return false if path.nil?

        if exists?
          File.delete(path)
          # 空のディレクトリも削除
          remove_empty_directories
        end

        true
      end

      # ファイルサイズを取得
      def size
        return 0 if path.nil? || !exists?

        File.size(path)
      end

      # ファイルをIOオブジェクトとして開く
      def open(&)
        return nil if path.nil? || !exists?

        File.open(path, 'rb', &)
      end

      private

      # ディレクトリが存在しない場合は作成
      def ensure_directory
        return false if path.nil?

        FileUtils.mkdir_p(File.dirname(path))
      end

      # 空のディレクトリを削除
      def remove_empty_directories
        return unless path

        dir = File.dirname(path)
        # コマンドIDディレクトリが空なら削除
        FileUtils.rmdir(dir) if Dir.empty?(dir)

        # ユーザーIDディレクトリが空なら削除
        parent_dir = File.dirname(dir)
        FileUtils.rmdir(parent_dir) if Dir.empty?(parent_dir)
      rescue Errno::ENOTEMPTY, Errno::ENOENT
        # ディレクトリが空でない、または既に存在しない場合は何もしない
      end
    end
  end
end
