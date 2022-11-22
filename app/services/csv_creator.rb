# frozen_string_literal: true

# 入力情報作成
class CsvCreator
  CRLF = "\r\n"

  def create_unfinished_zip(filename:)
    csv_filename = filename.sub(/zip\z/, 'csv')
    create_unfinished_csv(filename: csv_filename)
    make_zipfile(filename, csv_filename)
  end

  def create_finished_zip(filename:)
    csv_filename = filename.sub(/zip\z/, 'csv')
    create_finished_csv(filename: csv_filename)
    make_zipfile(filename, csv_filename)
  end

  def create_extended_zip(filename:)
    csv_filename = filename.sub(/zip\z/, 'csv')
    create_extended_csv(filename: csv_filename)
    make_zipfile(filename, csv_filename)
  end

  def make_zipfile(filename, csv_filename)
    Zip::File.open(filename, create: true) do |zipfile|
      zipfile.add(File.basename(csv_filename), csv_filename)
    end
    utf8_filename = make_utf8_filename(filename)
    utf8_csv_filename = make_utf8_filename(csv_filename)
    Zip::File.open(utf8_filename, create: true) do |zipfile|
      zipfile.add(File.basename(utf8_csv_filename), utf8_csv_filename)
    end
  end

  def create_unfinished_csv(filename:)
    utf8_filename = make_utf8_filename(filename)

    File.open(utf8_filename, 'wb') { |io| write_inp(io) }

    convert_to_sjis(from: utf8_filename, to: filename)

    Result.new(created: true, filename:)
  end

  def write_inp(io)
    csv_header = "人物ID,著者名,作品ID,作品名,仮名遣い種別,翻訳者名等,入力者名,校正者名,状態,状態の開始日,底本名,出版社名,入力に使用した版#{CRLF}"

    io.write(Shinonome::ExecCommand::BOM)
    io.write(csv_header)

    Work.unpublished.eager_load(:workers).eager_load(:people).eager_load(:original_books).order(:sortkey, :sortkey2, :id, 'people.sortkey').each do |work|
      not_author_text = not_author_names(work)
      original_book = work.original_books.where(worktype_id: 1).order(:id).first
      original_book_text = original_book&.title
      publisher_text = original_book&.publisher
      input_edition_text = original_book&.input_edition

      work.people.each do |person|
        array = [
          person.id, person.name,
          work.id, work.title, work.kana_type_name,
          not_author_text, work.inputer_text, work.proofreader_text,
          work.work_status.name, work.started_on,
          original_book_text, publisher_text, input_edition_text
        ]
        csv_body = CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
        io.write(csv_body)
      end
    end
  end

  def create_finished_csv(filename:)
    utf8_filename = make_utf8_filename(filename)

    File.open(utf8_filename, 'wb') { |io| write_finished(io) }

    convert_to_sjis(from: utf8_filename, to: filename)

    Result.new(created: true, filename:)
  end

  def write_finished(io)
    csv_header = "人物ID,著者名,作品ID,作品名,仮名遣い種別,翻訳者名等,入力者名,校正者名,状態,状態の開始日,底本名,出版社名,入力に使用した版,校正に使用した版#{CRLF}"

    io.write(Shinonome::ExecCommand::BOM)
    io.write(csv_header)

    Work.published.eager_load(:workers).eager_load(:people).eager_load(:original_books).order(:sortkey, :sortkey2, :id, 'people.sortkey').each do |work|
      not_author_text = not_author_names(work)
      original_book = work.original_books.where(worktype_id: 1).order(:id).first
      original_book_text = original_book&.title
      publisher_text = original_book&.publisher
      input_edition_text = original_book&.input_edition
      proof_edition_text = original_book&.proof_edition

      work.people.each do |person|
        array = [
          person.id, person.name,
          work.id, work.title, work.kana_type_name,
          not_author_text, work.inputer_text, work.proofreader_text,
          work.work_status.name, work.started_on,
          original_book_text, publisher_text, input_edition_text, proof_edition_text
        ]
        csv_body = CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
        io.write(csv_body)
      end
    end
  end

  def create_extended_csv(filename:)
    utf8_filename = make_utf8_filename(filename)

    File.open(utf8_filename, 'wb') { |io| write_extended(io) }

    convert_to_sjis(from: utf8_filename, to: filename)

    Result.new(created: true, filename:)
  end

  def write_extended(io) # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    csv_header = "作品ID,作品名,作品名読み,ソート用読み,副題,副題読み,原題,初出,分類番号,文字遣い種別,作品著作権フラグ,公開日,最終更新日,図書カードURL,人物ID,姓,名,姓読み,名読み,姓読みソート用,名読みソート用,姓ローマ字,名ローマ字,役割フラグ,生年月日,没年月日,人物著作権フラグ,底本名1,底本出版社名1,底本初版発行年1,入力に使用した版1,校正に使用した版1,底本の親本名1,底本の親本出版社名1,底本の親本初版発行年1,底本名2,底本出版社名2,底本初版発行年2,入力に使用した版2,校正に使用した版2,底本の親本名2,底本の親本出版社名2,底本の親本初版発行年2,入力者,校正者,テキストファイルURL,テキストファイル最終更新日,テキストファイル符号化方式,テキストファイル文字集合,テキストファイル修正回数,XHTML/HTMLファイルURL,XHTML/HTMLファイル最終更新日,XHTML/HTMLファイル符号化方式,XHTML/HTMLファイル文字集合,XHTML/HTMLファイル修正回数#{CRLF}" # rubocop:disable Layout/LineLength

    io.write(Shinonome::ExecCommand::BOM)
    io.write(csv_header)

    Work.published.eager_load(:workers).eager_load(:people).eager_load(:original_books).order(:sortkey, :sortkey2, :id, 'people.sortkey').each do |work|
      copyright_text = work.copyright_flag ? 'あり' : 'なし'

      orig_books = make_original_books(work)

      text_file = work.workfiles.select { |workfile| workfile.filetype.text? }.first
      html_file = work.workfiles.select { |workfile| workfile.filetype.html? }.first

      work.work_people.each do |work_person|
        person = work_person.person
        person_copyright_text = person.copyright_flag ? 'あり' : 'なし'

        array = [
          # 作品ID,作品名,作品名読み,ソート用読み,副題,副題読み,原題,
          work.id, work.title, work.title_kana, work.sortkey,
          work.subtitle, work.subtitle_kana, work.original_title,

          # 初出,分類番号,文字遣い種別,作品著作権フラグ,公開日,最終更新日,図書カードURL,
          work.first_appearance, work.bibclasses.first&.num, work.kana_type_name,
          copyright_text, work.started_on.strftime('%Y-%m-%d'), work.updated_at.strftime('%Y-%m-%d'), work.card_url,

          # 人物ID,姓,名,姓読み,名読み,姓読みソート用,名読みソート用,姓ローマ字,名ローマ字,
          person.id, person.last_name, person.first_name, person.last_name_kana, person.first_name_kana,
          person.sortkey, person.sortkey2, person.last_name_en, person.first_name_en,

          # 役割フラグ,生年月日,没年月日,人物著作権フラグ,
          work_person.role.name, person.born_on, person.died_on, person_copyright_text,

          # 底本名1,底本出版社名1,底本初版発行年1,入力に使用した版1,校正に使用した版1,
          # 底本の親本名1,底本の親本出版社名1,底本の親本初版発行年1,
          orig_books[:teihon][0]&.title,
          orig_books[:teihon][0]&.publisher,
          orig_books[:teihon][0]&.first_pubdate,
          orig_books[:teihon][0]&.input_edition,
          orig_books[:teihon][0]&.proof_edition,
          orig_books[:oyahon][0]&.title,
          orig_books[:oyahon][0]&.publisher,
          orig_books[:oyahon][0]&.first_pubdate,
          orig_books[:teihon][1]&.title,
          orig_books[:teihon][1]&.publisher,
          orig_books[:teihon][1]&.first_pubdate,
          orig_books[:teihon][1]&.input_edition,
          orig_books[:teihon][1]&.proof_edition,
          orig_books[:oyahon][1]&.title,
          orig_books[:oyahon][1]&.publisher,
          orig_books[:oyahon][1]&.first_pubdate,

          # 入力者,校正者,
          work.inputer_text, work.proofreader_text,

          # テキストファイルURL,テキストファイル最終更新日,テキストファイル符号化方式,テキストファイル文字集合,テキストファイル修正回数,
          text_file&.download_url, text_file&.updated_at, text_file&.file_encoding&.name, text_file&.charset&.name, text_file&.revision_count,
          # XHTML/HTMLファイルURL,XHTML/HTMLファイル最終更新日,XHTML/HTMLファイル符号化方式,XHTML/HTMLファイル文字集合,XHTML/HTMLファイル修正回数
          html_file&.download_url, html_file&.updated_at, html_file&.file_encoding&.name, html_file&.charset&.name, html_file&.revision_count
        ]
        csv_body = CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
        io.write(csv_body)
      end
    end
  end

  def make_original_books(work)
    original_books = { teihon: [], oyahon: [] }

    work.original_books.order(:id).each do |original_book|
      if original_book.worktype_id == 1
        original_books[:teihon] << original_book
      else
        original_books[:oyahon] << original_book
      end
    end

    original_books
  end

  def make_utf8_filename(filename)
    filename.sub(/\.[a-z]+\z/) { |matched| "_utf8#{matched}" }
  end

  def convert_to_sjis(from:, to:)
    File.open(to, 'wb:cp932') do |io_to|
      File.open(from, 'rb:BOM|utf-8') do |io_from|
        io_from.each_line do |line|
          io_to.write(line.encode('cp932'))
        end
      end
    end
  end

  def not_author_names(work)
    not_author_names =
      work.work_people.order(:id).select { |work_person| work_person.not_author? }.map { |work_person| work_person.person.name }
    not_author_names.join('、')
  end

  # 結果返却用
  class Result
    attr_reader :filename

    def initialize(created:, filename:)
      @created = created
      @filename = filename
    end

    def created?
      @created
    end
  end
end
