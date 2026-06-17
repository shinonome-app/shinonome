# frozen_string_literal: true

module NatsuzoraContext
  # Builds the context hash for cards/show.ntzr (図書カード).
  class CardBuilder
    def initialize(work, person_id)
      @work = work
      @person_id = person_id
    end

    def build
      main_site_url = Rails.application.config.x.main_site_url.to_s
      first_author_id = @work.first_author&.id || @person_id
      bgcolor = @work.copyright? ? 'bg-rose-50' : 'bg-sky-50'
      xhtml_workfile = @work.xhtml_link
      xhtml_url = xhtml_workfile ? workfile_download_url(xhtml_workfile, first_author_id, main_site_url) : nil
      bibclasses_text = @work.bibclasses.map do |b|
        b.note.present? ? "#{b.name}#{b.num} #{b.note}" : "#{b.name} #{b.num}"
      end.join(', ')

      {
        'page_title' => "図書カード：#{@work.title} | 青空文庫",
        'bgcolor' => bgcolor,
        'work_id' => @work.id,
        'person_id' => @person_id,
        'first_author_id' => first_author_id,
        'title' => @work.title.to_s,
        'title_kana' => @work.title_kana.to_s,
        'subtitle' => @work.subtitle.to_s,
        'subtitle_kana' => @work.subtitle_kana.to_s,
        'original_title' => @work.original_title.to_s,
        'collection' => @work.collection.to_s,
        'collection_kana' => @work.collection_kana.to_s,
        'kana_type' => @work.kana_type&.name.to_s,
        'started_on' => @work.started_on.to_s,
        'note' => @work.note_without_link_tag.to_s,
        'first_appearance' => @work.first_appearance.to_s,
        'description' => nl2br(@work.description.to_s),
        'has_copyright' => @work.copyright?,
        'card_path' => "/cards/#{format('%06d', first_author_id)}/card#{@work.id}.html",
        'xhtml_url' => xhtml_url,
        'bibclasses_text' => bibclasses_text,
        'booklog_url' => "http://booklog.jp/item/7/#{@work.id}",
        'voyger_url' => "http://aozora.binb.jp/reader/main.html?cid=#{@work.id}",
        'airzoshi_url' => "https://www.satokazzz.com/airzoshi/reader.php?action=aozora&id=#{@work.id}",
        'rodoku_url' => "https://www.google.co.jp/search?hl=ja&source=hp&q=青空文庫+朗読+#{@work.title}",
        'authors' => build_authors,
        'translators' => build_translators,
        'editors' => build_editors,
        'workfiles' => build_workfiles(first_author_id, main_site_url),
        'original_books' => build_original_books,
        'work_workers' => build_work_workers,
        'bibclasses' => build_bibclasses,
        'work_people_details' => build_work_people_details,
        'sites' => build_sites
      }
    end

    private

    def nl2br(str)
      str.gsub("\r\n", '<br>').gsub("\n", '<br>')
    end

    def build_authors
      @work.work_people.select { |wp| wp.role_id == 1 }.map do |wp|
        { 'id' => wp.person.id, 'name' => wp.person.name, 'name_kana' => wp.person.name_kana,
          'copyright_flag' => wp.person.copyright_flag }
      end
    end

    def build_translators
      @work.work_people.select { |wp| wp.role_id == 2 }.map do |wp|
        { 'id' => wp.person.id, 'name' => wp.person.name, 'name_kana' => wp.person.name_kana }
      end
    end

    def build_editors
      @work.work_people.select { |wp| wp.role_id == 3 }.map do |wp|
        { 'id' => wp.person.id, 'name' => wp.person.name, 'name_kana' => wp.person.name_kana }
      end
    end

    def build_workfiles(first_author_id, main_site_url)
      @work.workfiles.map do |file|
        download_url = workfile_download_url(file, first_author_id, main_site_url)
        {
          'id' => file.id,
          'filename' => file.filename.to_s,
          'filesize' => file.filesize,
          'filetype' => file.filetype&.name.to_s,
          'filetype_id' => file.filetype_id,
          'is_html' => file.html?,
          'compresstype' => file.compresstype&.name.to_s,
          'charset' => file.charset&.name.to_s,
          'file_encoding' => file.file_encoding&.name.to_s,
          'url' => file.url.to_s,
          'download_url' => download_url || '',
          'download_display' => download_url || '',
          'registered_on' => file.registered_on.to_s,
          'last_updated_on' => file.last_updated_on.to_s
        }
      end
    end

    def build_original_books
      @work.original_books.each_with_index.map do |ob, i|
        {
          'is_first' => i == 0,
          'title' => ob.title.to_s,
          'publisher' => ob.publisher.to_s,
          'first_pubdate' => ob.first_pubdate.to_s,
          'input_edition' => ob.input_edition.to_s,
          'proof_edition' => ob.proof_edition.to_s,
          'booktype' => ob.booktype&.name.to_s,
          'booktype_id' => ob.booktype_id
        }
      end
    end

    def build_work_workers
      @work.work_workers.map do |ww|
        { 'name' => ww.worker&.name.to_s, 'role' => ww.worker_role&.name.to_s }
      end
    end

    def build_bibclasses
      @work.bibclasses.map do |b|
        { 'name' => b.name, 'num' => b.num, 'note' => b.note.to_s }
      end
    end

    def build_work_people_details
      @work.work_people.each_with_index.map do |wp, i|
        person = wp.person
        {
          'index' => i,
          'is_first' => i == 0,
          'role_name' => wp.role&.name.to_s,
          'person_id' => person.id,
          'name' => person.name,
          'name_kana' => person.name_kana,
          'name_en' => person.name_en.to_s,
          'born_on' => person.born_on.to_s,
          'died_on' => person.died_on.to_s,
          'description' => nl2br(person.description.to_s)
        }
      end
    end

    def build_sites
      @work.sites.map do |s|
        { 'name' => s.name.to_s, 'url' => s.url.to_s }
      end
    end

    def workfile_download_url(workfile, person_id, main_site_url)
      return workfile.url if workfile.url.present?
      return nil if workfile.filename.blank?

      "#{main_site_url}/cards/#{format('%06d', person_id)}/files/#{workfile.filename}"
    end
  end
end
