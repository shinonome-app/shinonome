# frozen_string_literal: true

# ダミーファイル生成
class SampleFileGenerator
  ## Workfiles

  def text_convert(work)
    header = generate_header(work)
    footer = generate_footer(work)

    # rubocop:disable Layout/HeredocIndentation
    sample_text_template = <<~TEXT
#{header}

-------------------------------------------------------
【テキスト中に現れる記号について】

《》：ルビ
（例）青空文庫《あおぞらぶんこ》

［＃］：入力者注　主に外字の説明や、傍点の位置の指定
（例）［＃７字下げ］
-------------------------------------------------------

［＃７字下げ］一［＃「一」は中見出し］

　青空文庫《あおぞらぶんこ》形式のサンプルファイルです。

［＃７字下げ］二［＃「二」は中見出し］

　このファイルはサンプルとして自動的に生成されたものです。記述されている底本は存在しません。ご了承ください。



#{footer}
    TEXT
    # rubocop:enable Layout/HeredocIndentation

    sample_text_template.gsub("\n", "\r\n")
  end

  def generate_header(work)
    buf = "#{work.title}\n"
    buf << "#{work.original_title}\n" if work.original_title
    buf << "#{work.subtitle}\n" if work.subtitle
    work.work_people.order(:role_id).each do |work_person|
      buf << "#{work_person.person.name}\n"
    end

    buf
  end

  def generate_footer(work)
    buf = ''.dup
    work.original_books.order(:worktype_id).each do |original_book|
      worktype = original_book.worktype.name
      buf << "#{worktype}：「#{original_book.title}」#{original_book.publisher}\n"
      buf << "　　　#{original_book.first_pubdate}#{original_book.input_edition}発行\n"
    end
    buf << (work.inputer_text.blank? ? "入力：？？？\n" : "入力：#{work.inputer_text}\n")
    buf << (work.proofreader_text.blank? ? "校正：？？？\n" : "校正：#{work.proofreader_text}\n")
    buf << "#{work.updated_at_text}作成\n"

    # rubocop:disable Layout/HeredocIndentation
    buf << <<-TEXT
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。
    TEXT
    # rubocop:enable Layout/HeredocIndentation

    buf
  end

  def generate_sample_zip(workfile)
    work = workfile.work
    zipfile_name = nil

    Dir.mktmpdir do |folder|
      sample_filename = 'sample.txt'
      sample_path = File.join(folder, sample_filename)
      File.write(sample_path, text_convert(work), encoding: 'Shift_JIS')

      input_filenames = [sample_filename]
      zip_file = "#{work.id}_ruby_#{workfile.id}.zip"
      zipfile_name = File.join(folder, zip_file)

      Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
        input_filenames.each do |filename|
          zipfile.add(filename, File.join(folder, filename))
        end
      end

      if workfile.respond_to?(:workdata)
        workfile.workdata.attach(io: File.open(zipfile_name), filename: zip_file, content_type: 'application/zip')

        workfile.filename = zip_file
      end
      # workfile.filesize = File.size(zipfile_name)
    end

    zipfile_name
  end

  def generate_sample_html(workfile)
    work = workfile.work
    html_file = "#{work.id}_#{workfile.id}.html"

    Dir.mktmpdir do |folder|
      htmlfile_path = File.join(folder, html_file)

      content = text_convert(work).gsub(/\r\n/, "\n")
      html_data = "<html>\n<head>\n<title>#{work.title}</title>\n</head>\n<body>\n<pre>\n#{content}</pre>\n</body>\n</html>\n"
      File.write(htmlfile_path, html_data)

      if workfile.respond_to?(:workdata)
        File.open(htmlfile_path) do |f|
          workfile.workdata.attach(io: f, filename: html_file, content_type: 'text/html')
        end
        workfile.filename = html_file
      end
    end
  end
end
