# frozen_string_literal: true

require 'zip'
require 'tmpdir'

Workfile.find_each do |workfile|
  # filesystem上のファイルを削除
  workfile.filesystem.delete if workfile.filesystem.exists?
end
Workfile.connection.execute('TRUNCATE TABLE workfiles, workfile_secrets;')

# rubocop:disable Layout/HeredocIndentation
SAMPLE_TEXT_FORMAT = <<TEXT
<%= header %>

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



<%= footer %>
TEXT
# rubocop:enable Layout/HeredocIndentation

## Workfiles

def erubi_convert(template, work)
  # rubocop:disable Lint/UselessAssignment
  header = generate_header(work)
  footer = generate_footer(work)

  eval(Erubi::Engine.new(template).src).gsub("\n", "\r\n") # rubocop:disable Security/Eval
  # rubocop:enable Lint/UselessAssignment
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
  work.original_books.order(:booktype_id).each do |original_book|
    booktype = original_book.booktype.name
    buf << "#{booktype}：「#{original_book.title}」#{original_book.publisher}\n"
    buf << "　　　#{original_book.first_pubdate}#{original_book.input_edition}発行\n"
  end
  buf << if work.inputer_text.blank?
           "入力：？？？\n"
         else
           "入力：#{work.inputer_text}\n"
         end
  buf << if work.proofreader_text.blank?
           "校正：？？？\n"
         else
           "校正：#{work.proofreader_text}\n"
         end
  buf << "#{work.updated_at.strftime('%Y年%m月%d日')}作成\n".gsub('年0', '年').gsub('月0', '月')
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
    File.write(sample_path, erubi_convert(SAMPLE_TEXT_FORMAT, work), encoding: 'Shift_JIS')

    input_filenames = [sample_filename]
    zip_file = "#{work.id}_ruby_#{workfile.id}.zip"
    zipfile_name = File.join(folder, zip_file)

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, File.join(folder, filename))
      end
    end

    workfile.filesystem.copy_from(zipfile_name)
    workfile.update!(filename: zip_file, filesize: File.size(zipfile_name))
  end

  zipfile_name
end

def generate_sample_html(workfile)
  work = workfile.work
  html_file = "#{work.id}_#{workfile.id}.html"

  Dir.mktmpdir do |folder|
    htmlfile_path = File.join(folder, html_file)

    content = erubi_convert(SAMPLE_TEXT_FORMAT, work).gsub("\r\n", "\n")
    html_data = "<html>\n<head>\n<title>#{work.title}</title>\n</head>\n<body>\n<pre>\n#{content}</pre>\n</body>\n</html>\n"
    File.write(htmlfile_path, html_data)

    workfile.filesystem.copy_from(htmlfile_path)
    workfile.update!(filename: html_file, filesize: File.size(htmlfile_path))
  end
end

work_id_status_list = Work.pluck(:id, :work_status_id)

work_id_status_list.each do |work_id, status|
  # 校了と公開のみ
  next unless [1, 10].include?(status)

  # ZIPファイルの作成
  zip_workfile = Workfile.new(
    work_id: work_id,
    filename: '', # 一時的なファイル名、後で更新
    charset_id: 1, # JIS X 0208
    compresstype_id: 2, # zip
    file_encoding_id: 1, # Shift_JIS
    filetype_id: 1, # テキストファイル(ルビあり) rtxt
    revision_count: 1,
    registered_on: Time.current,
    last_updated_on: Time.current,
    filesize: 10000 + (rand(2000) * 17),
    created_at: Time.current,
    updated_at: Time.current
  )
  zip_workfile.build_workfile_secret(memo: 'ZIPファイル')
  zip_workfile.save!

  # HTMLファイルの作成
  html_workfile = Workfile.new(
    work_id: work_id,
    filename: '', # 一時的なファイル名、後で更新
    charset_id: 1, # JIS X 0208
    compresstype_id: 1, # 圧縮なし
    file_encoding_id: 1, # Shift_JIS
    filetype_id: 3, # htmlファイル
    revision_count: 1,
    registered_on: Time.current,
    last_updated_on: Time.current,
    filesize: 10000 + (rand(2000) * 17),
    created_at: Time.current,
    updated_at: Time.current
  )
  html_workfile.build_workfile_secret(memo: 'HTMLファイル')
  html_workfile.save!

  # ファイル生成
  generate_sample_zip(zip_workfile)
  generate_sample_html(html_workfile)
end
