# frozen_string_literal: true

class Workfile < ApplicationRecord
  # Workfileのファイルシステム操作を担当するクラス
  class Filesystem
    include ActiveModel::Model

    attr_accessor :workfile

    def initialize(workfile)
      @workfile = workfile
    end

    # ファイルシステム上のパス
    def path
      filename = workfile.filename.presence || workfile.generate_filename
      return nil if filename.blank?

      Rails.root.join('data/workfiles/cards', workfile.work.card_person_id.to_s, 'files', filename)
    end

    # ファイルが存在するか
    def exists?
      return false if path.nil?

      File.exist?(path)
    end

    # アップロードされたファイルをファイルシステムに保存
    def save(uploaded_file)
      return false if path.nil?

      ensure_directory
      File.binwrite(path, uploaded_file.read)
      workfile.update!(filesize: File.size(path))
    end

    # ファイルシステムからファイル内容を読み込み
    def read
      return nil if path.nil? || !exists?

      File.read(path)
    end

    # ファイルシステムからファイルを削除
    def delete
      return false if path.nil?

      File.delete(path) if exists?
    end

    # ファイルサイズを取得
    def size
      return 0 if path.nil? || !exists?

      File.size(path)
    end

    private

    # ディレクトリが存在しない場合は作成
    def ensure_directory
      return false if path.nil?

      FileUtils.mkdir_p(File.dirname(path))
    end
  end
end
