# frozen_string_literal: true

# Workfileのファイルのファイルタイプを変換する
#
# 主にテキストでアップロードされたファイルをzipやHTMLに変換するために使う想定
class WorkfileConverter
  def convert_format(workfile)
    filename = workfile.filename
    return Result.new(converted: false, workfile:) if File.extname(filename) != '.txt'

    # テスト環境ではActiveStorageを使用、本番環境ではFilesystemを使用
    if Rails.env.test? && workfile.workdata.attached?
      convert_format_activestorage(workfile)
    elsif workfile.filesystem.exists?
      convert_format_filesystem(workfile)
    else
      Result.new(converted: false, workfile:)
    end
  end

  private

  # ActiveStorage版（テスト用）
  def convert_format_activestorage(workfile)
    if workfile.html?
      convert_text_to_html(workfile)
    elsif workfile.zip?
      convert_text_to_zip(workfile)
    else
      Result.new(converted: false, workfile:)
    end
  end

  # Filesystem版（本番用）
  def convert_format_filesystem(workfile)
    if workfile.html?
      convert_to_html_filesystem(workfile)
    elsif workfile.zip?
      convert_to_zip_filesystem(workfile)
    else
      Result.new(converted: false, workfile:)
    end
  end

  # ActiveStorage用のHTML変換
  def convert_text_to_html(workfile)
    new_filename = workfile.filename.gsub(/\.txt$/, '.html')
    Dir.mktmpdir do |dir|
      src_file = File.join(dir, 'source.txt')
      dest_file = File.join(dir, 'output.html')

      begin
        workfile.workdata.open do |file|
          content = file.read
          content.force_encoding('Shift_JIS')
          File.binwrite(src_file, content)
        end

        # Aozora2Html.new(src_file, dest_file).process
        system('bundle', 'exec', 'aozora2html', src_file, dest_file)
      rescue StandardError => _e
        return Result.new(converted: false, workfile:)
      end

      workfile.filename = new_filename

      workfile.workdata.attach(
        io: File.open(dest_file),
        filename: new_filename,
        content_type: 'text/html',
        identify: false
      )

      workfile.save!
    end

    Result.new(converted: true, workfile:)
  rescue StandardError => _e
    Result.new(converted: false, workfile:)
  end

  # ActiveStorage用のZIP変換
  def convert_text_to_zip(workfile)
    new_filename = workfile.filename.gsub(/\.txt$/, '.zip')

    Dir.mktmpdir do |dir|
      src_file = File.join(dir, 'source.txt')
      dest_file = File.join(dir, 'output.zip')

      begin
        workfile.workdata.open do |file|
          content = file.read
          content.force_encoding('Shift_JIS')
          File.binwrite(src_file, content)
        end

        Zip::File.open(dest_file, create: true) do |zipfile|
          zipfile.add(workfile.filename, src_file)
        end
      rescue StandardError => _e
        return Result.new(converted: false, workfile:)
      end

      workfile.filename = new_filename

      workfile.workdata.attach(
        io: File.open(dest_file),
        filename: new_filename,
        content_type: 'application/zip',
        identify: false
      )

      workfile.save!
    end

    Result.new(converted: true, workfile:)
  rescue StandardError => _e
    Result.new(converted: false, workfile:)
  end

  # Filesystem用のHTML変換
  def convert_to_html_filesystem(workfile)
    new_filename = workfile.filename.gsub(/\.txt$/, '.html')

    begin
      # ソースファイルから内容を読み込み
      content = File.read(workfile.filesystem.path, encoding: 'Shift_JIS').force_encoding('UTF-8')

      # aozora2html変換
      html_content = if workfile.using_ruby?
                       Aozora2Html.new.aozora_to_html(content, use_ruby: true)
                     else
                       Aozora2Html.new.aozora_to_html(content, use_ruby: false)
                     end

      # ファイル名を更新
      workfile.filename = new_filename

      # HTMLファイルとして保存（新しいパスに）
      File.write(workfile.filesystem.path, html_content, encoding: 'UTF-8')

      workfile.save!
    rescue StandardError => _e
      return Result.new(converted: false, workfile:)
    end

    Result.new(converted: true, workfile:)
  rescue StandardError => _e
    Result.new(converted: false, workfile:)
  end

  # Filesystem用のZIP変換
  def convert_to_zip_filesystem(workfile)
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
