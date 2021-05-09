# frozen_string_literal: true

require 'zip'
require 'tmpdir'

Bookfile.all.each do |bookfile|
  bookfile.bookdata.purge if bookfile.bookdata.attached?
end
Bookfile.connection.execute('TRUNCATE TABLE bookfiles;')

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

## Bookfiles

def erubi_convert(template, book)
  # rubocop:disable Lint/UselessAssignment
  header = generate_header(book)
  footer = generate_footer(book)

  eval(Erubi::Engine.new(template).src).gsub("\n", "\r\n") # rubocop:disable Security/Eval
  # rubocop:enable Lint/UselessAssignment
end

def generate_header(book)
  buf = "#{book.title}\n"
  buf << "#{book.original_title}\n" if book.original_title
  buf << "#{book.subtitle}\n" if book.subtitle
  book.book_people.order(:role_id).each do |book_person|
    buf << "#{book_person.person.name}\n"
  end

  buf
end

def generate_footer(book)
  buf = ''.dup
  book.original_books.order(:booktype_id).each do |original_book|
    booktype = original_book.booktype.name
    buf << "#{booktype}：「#{original_book.title}」#{original_book.publisher}\n"
    buf << "　　　#{original_book.first_pubdate}#{original_book.input_edition}発行\n"
  end
  buf << if book.inputer_text.blank?
           "入力：？？？\n"
         else
           "入力：#{book.inputer_text}\n"
         end
  buf << if book.proofreader_text.blank?
           "校正：？？？\n"
         else
           "校正：#{book.proofreader_text}\n"
         end
  buf << "#{book.updated_at.strftime('%Y年%m月%d日')}作成\n".gsub('年0', '年').gsub('月0', '月')
  # rubocop:disable Layout/HeredocIndentation
  buf << <<-TEXT
青空文庫作成ファイル：
このファイルは、インターネットの図書館、青空文庫（https://www.aozora.gr.jp/）で作られました。入力、校正、制作にあたったのは、ボランティアの皆さんです。
  TEXT
  # rubocop:enable Layout/HeredocIndentation

  buf
end

def generate_sample_zip(bookfile)
  book = bookfile.book
  zipfile_name = nil

  Dir.mktmpdir do |folder|
    sample_filename = 'sample.txt'
    sample_path = File.join(folder, sample_filename)
    File.write(sample_path, erubi_convert(SAMPLE_TEXT_FORMAT, book), encoding: 'Shift_JIS')

    input_filenames = [sample_filename]
    zip_file = "#{book.id}_ruby_#{bookfile.id}.zip"
    zipfile_name = File.join(folder, zip_file)

    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      input_filenames.each do |filename|
        zipfile.add(filename, File.join(folder, filename))
      end
    end

    bookfile.bookdata.attach(io: File.open(zipfile_name), filename: zip_file, content_type: 'application/zip')

    bookfile.filename = zip_file
    bookfile.filesize = File.size(zipfile_name)
  end

  zipfile_name
end

book_id_status_list = Book.all.pluck(:id, :book_status_id)
user_id_list = User.all.pluck(:id)

bookfiles = book_id_status_list.map do |n, status|
  # 校了と公開のみ
  next unless [1, 10].include?(status)

  {
    book_id: n,
    filename: "#{n}_ruby_NNN.zip",
    charset_id: 1, # JIS X 0208
    compresstype_id: 2, # zip
    file_encoding_id: 1, # Shift_JIS
    filetype_id: 1, # テキストファイル(ルビあり) rtxt
    user_id: user_id_list.sample,
    revision_count: 1,
    opened_on: Time.current,
    note: "備考#{n}",
    created_at: Time.current,
    updated_at: Time.current
  }
end.compact

Bookfile.insert_all(bookfiles)

Bookfile.transaction do
  Bookfile.includes(:book).all.each do |bookfile|
    generate_sample_zip(bookfile)
    bookfile.save
  end
end
