# frozen_string_literal: true

# Workfileのファイルのファイルタイプを変換する
#
# 主にテキストでアップロードされたファイルをzipやHTMLに変換するために使う想定
class WorkfileConverter
  def convert_format(workfile)
    filename = workfile.filename
    return Result.new(converted: false, workfile: workfile) if File.extname(filename) != '.txt'

    if workfile.html?
      convert_text_to_html(workfile)
    elsif workfile.zip?
      convert_text_to_zip(workfile)
    end
  end

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
        return Result.new(converted: false, workfile: workfile)
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

    Result.new(converted: true, workfile: workfile)
  rescue StandardError => _e
    Result.new(converted: false, workfile: workfile)
  end

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
        return Result.new(converted: false, workfile: workfile)
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

    Result.new(converted: true, workfile: workfile)
  rescue StandardError => _e
    Result.new(converted: false, workfile: workfile)
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
