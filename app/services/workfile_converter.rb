# frozen_string_literal: true

# Workfileのファイルのファイルタイプを変換する
#
# 主にテキストでアップロードされたファイルをzipやHTMLに変換するために使う想定
class WorkfileConverter
  def convert_format(workfile)
    filename = workfile.filename
    return Result.new(converted: false, workfile:) if File.extname(filename) != '.txt'

    # Phase 3: Filesystemのみ使用
    if workfile.filesystem.exists?
      convert_format_filesystem(workfile)
    else
      Result.new(converted: false, workfile:)
    end
  end

  private

  # Filesystem版
  def convert_format_filesystem(workfile)
    if workfile.html?
      convert_to_html(workfile)
    elsif workfile.zip?
      convert_to_zip(workfile)
    else
      Result.new(converted: false, workfile:)
    end
  end

  # HTML変換
  def convert_to_html(workfile)
    new_filename = workfile.filename.gsub(/\.txt$/, '.html')

    Dir.mktmpdir do |dir|
      src_file = File.join(dir, 'source.txt')
      dest_file = File.join(dir, 'output.html')

      begin
        # ソースファイルをコピー（Shift_JISエンコーディングを保持）
        FileUtils.cp(workfile.filesystem.path, src_file)

        # 空ファイルチェック
        if File.zero?(src_file)
          return Result.new(converted: false, workfile:)
        end

        # aozora2html gemを使用してHTML変換
        # gemはコマンドライン形式で使用する必要がある
        # エラー出力は/dev/nullにリダイレクト
        success = system('bundle', 'exec', 'aozora2html', src_file, dest_file, err: :out, out: File::NULL)
        
        unless success && File.exist?(dest_file)
          return Result.new(converted: false, workfile:)
        end

        # ファイル名を更新
        workfile.filename = new_filename

        # HTMLファイルを新しいパスにコピー
        FileUtils.cp(dest_file, workfile.filesystem.path)

        workfile.save!
      rescue StandardError => _e
        return Result.new(converted: false, workfile:)
      end
    end

    Result.new(converted: true, workfile:)
  rescue StandardError => _e
    Result.new(converted: false, workfile:)
  end

  # ZIP変換
  def convert_to_zip(workfile)
    new_filename = workfile.filename.gsub(/\.txt$/, '.zip')

    Dir.mktmpdir do |dir|
      src_file = File.join(dir, 'source.txt')
      dest_file = File.join(dir, 'output.zip')

      begin
        # ソースファイルから内容を読み込み
        content = File.read(workfile.filesystem.path)
        File.binwrite(src_file, content)

        Zip::File.open(dest_file, create: true) do |zipfile|
          zipfile.add(workfile.filename, src_file)
        end
      rescue StandardError => _e
        return Result.new(converted: false, workfile:)
      end

      # ファイル名を更新
      workfile.filename = new_filename

      # ZIPファイルを新しいパスにコピー
      FileUtils.cp(dest_file, workfile.filesystem.path)

      workfile.save!
    end

    Result.new(converted: true, workfile:)
  rescue StandardError => _e
    Result.new(converted: false, workfile:)
  end

  # 結果返却用
  class Result
    attr_reader :workfile

    def initialize(converted:, workfile:)
      @converted = converted
      @workfile = workfile
    end

    def converted?
      @converted
    end
  end
end
