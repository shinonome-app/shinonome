# frozen_string_literal: true

require 'csv'

# データ移行用
class MigrateData
  DEFAULT_DATE = '2024-01-01'

  # rubocop:disable Rails/SkipsModelValidations

  def initialize(data_dir: '/var/tmp/aozora2_out')
    @data_dir = data_dir
  end

  def migrate_data
    ApplicationRecord.transaction do
      truncate_table(
        :base_people, # o
        :bibclasses, # o
        :news_entries, # o
        :original_books, # o
        :original_book_secrets, # o
        :people, # o
        :person_secrets, # o
        :person_sites, # o
        :proofreads, # o
        :receipts, # o
        :sites, # o
        :site_secrets, # o
        :users, # o
        :work_people, # o
        :work_sites, # o
        :work_workers, # o
        :workers, # o
        :worker_secrets, # o
        :workfiles, # o
        :workfile_secrets, # o
        :works, # o
        :work_secrets, # o
        :typesettings # -
      )
      load_users('users.csv')
      load_news('news_entries.csv')
      load_receipts('receipts.csv')
      load_people('people.csv')
      load_works('works.csv')
      load_base_people('base_people.csv')
      load_work_people('work_people.csv')
      load_original_books('originalbooks.csv')
      load_bibclasses('bibclasses.csv')
      load_workers('workers.csv')
      load_work_workers('work_workers.csv')
      load_sites('sites.csv')
      load_person_sites('person_sites.csv')
      load_work_sites('work_sites.csv')
      load_workfiles('workfiles.csv')
      load_proofreads('proofreads.csv')
    end
  end

  private

  def load_users(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        username: row[1],
        old_password: row[2],
        email: "dummy-#{row[0]}@example.jp"
        # encrypted_password: SecureRandom.hex(5),
      }
    end
    Shinonome::User.insert_all(buf)
    update_serial('users')
  end

  def load_news(filename)
    news_entries = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      news_entries << { id: row[0], published_on: row[1], title: row[2], body: force_lf(row[3]), flag: row[4] }
    end
    NewsEntry.insert_all(news_entries)
    update_serial('news_entries')
  end

  def load_bibclasses(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        name: row[2],
        num: row[3]
      }
    end
    Bibclass.insert_all(buf)
    update_serial('bibclasses')
  end

  def load_people(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        last_name: row[1],
        last_name_kana: row[2],
        last_name_en: row[3],
        first_name: row[4],
        first_name_kana: row[5],
        first_name_en: row[6],
        born_on: row[7],
        died_on: row[8],
        copyright_flag: row[9],
        email: row[10],
        url: row[11],
        description: row[12],
        # old_note_user: row[13],
        basename: row[14],
        # note_secret: row[15],
        updated_by: row[17],
        sortkey: row[18],
        sortkey2: row[19],
        input_count: row[20],
        publish_count: row[21],

        created_at: row[16].presence || DEFAULT_DATE,
        updated_at: row[16].presence || DEFAULT_DATE
      }

      # person_secrets
      if row[15].present?
        buf2 << {
          person_id: row[0],
          memo: row[15],
          created_at: row[16].presence || DEFAULT_DATE,
          updated_at: row[16].presence || DEFAULT_DATE
        }
      end
    end
    Person.insert_all(buf)
    update_serial('people')
    Shinonome::PersonSecret.insert_all(buf2)
    update_serial('person_secrets')
  end

  def load_base_people(filename)
    ignore_person_ids = %w[
      15
      45
      49
      132
      217
      433
      962
      964
      976
      979
      982
      983
      985
      986
      987
      988
      991
      993
      994
      995
      996
      998
      999
      1000
      1001
      1002
      1003
      1004
      1005
      1022
      1023
      1024
      1031
      1032
      1033
      2145
    ]

    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      next if ignore_person_ids.include?(row[1])

      buf << {
        id: row[0],
        person_id: row[1],
        original_person_id: row[2]
      }
    end
    BasePerson.insert_all(buf)
    update_serial('base_people')
  end

  def load_works(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      if row[13].to_i == 1
        note = row[16]
        memo = nil
      else
        note = nil
        memo = row[16]
      end
      buf << {
        id: row[0],
        title: row[1],
        title_kana: row[2],
        subtitle: row[3],
        subtitle_kana: row[4],
        collection: row[5],
        collection_kana: row[6],
        original_title: row[7],
        kana_type_id: row[8],
        # old_author: ignored
        first_appearance: row[10],
        description: row[11],
        # old_description_person_id: unused
        work_status_id: row[13],
        started_on: row[14].presence || '2001-01-01', # card No.2223
        copyright_flag: row[15],
        note:,
        # orig_text: row[17], -> to secrets

        created_at: row[18].presence || DEFAULT_DATE,
        updated_at: row[18].presence || DEFAULT_DATE,

        user_id: row[19].presence || 1,
        # old_update_flag: ignored
        sortkey: row[21]
      }

      # work_secrets
      if row[17].present?
        buf2 << {
          work_id: row[0],
          orig_text: row[17],
          memo:
        }
      end
    end
    Work.insert_all(buf)
    update_serial('works')
    Shinonome::WorkSecret.insert_all(buf2)
    update_serial('work_secrets')
  end

  def load_work_people(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        person_id: row[2],
        role_id: row[3]
      }
    end
    WorkPerson.insert_all(buf)
    update_serial('work_people')
  end

  def load_original_books(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        title: row[2],
        publisher: row[3],
        first_pubdate: row[4],
        input_edition: row[5],
        proof_edition: row[6],
        booktype_id: row[7]
        # secret_memo: row[8],
      }

      if row[8].present?
        buf2 << {
          original_book_id: row[0],
          memo: row[8]
        }
      end
    end
    OriginalBook.insert_all(buf)
    update_serial('original_books')
    Shinonome::OriginalBookSecret.insert_all(buf2)
    update_serial('original_book_secrets')
  end

  def load_workers(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        name: row[1],
        name_kana: row[2],
        # old_email:
        # old_url:
        # old_note:
        created_at: row[6].presence || DEFAULT_DATE,
        updated_at: row[6].presence || DEFAULT_DATE,
        updated_by: row[7],
        sortkey: row[8]
      }

      buf2 << {
        worker_id: row[0],
        email: row[3],
        url: row[4],
        note: row[5]
      }
    end
    Worker.insert_all(buf)
    update_serial('workers')
    Shinonome::WorkerSecret.insert_all(buf2)
    update_serial('worker_secrets')
  end

  def load_work_workers(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        worker_id: row[2],
        worker_role_id: row[3]
      }
    end
    WorkWorker.insert_all(buf)
    update_serial('work_workers')
  end

  def load_sites(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        name: row[1],
        url: row[2],
        # secret_owner_name:
        # secret_email:
        # secret_memo:
        updated_by: row[7],
        created_at: row[6].presence || DEFAULT_DATE,
        updated_at: row[6].presence || DEFAULT_DATE
      }

      if row[3].present? || row[4].present? || row[5].present?
        buf2 << {
          site_id: row[0],
          owner_name: row[3],
          email: row[4],
          memo: row[5],
          created_at: row[6].presence || DEFAULT_DATE,
          updated_at: row[6].presence || DEFAULT_DATE
        }
      end
    end
    Site.insert_all(buf)
    update_serial('sites')
    Shinonome::SiteSecret.insert_all(buf2)
    update_serial('site_secrets')
  end

  def load_person_sites(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        person_id: row[1],
        site_id: row[2]
      }
    end
    PersonSite.insert_all(buf)
    update_serial('person_sites')
  end

  def load_work_sites(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        site_id: row[2]
      }
    end
    WorkSite.insert_all(buf)
    update_serial('work_sites')
  end

  def load_workfiles(filename)
    buf = []
    buf2 = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      buf << {
        id: row[0],
        work_id: row[1],
        filetype_id: row[2],
        compresstype_id: row[3],
        filesize: row[4],
        # old_user_id: row[5],
        url: row[6],
        filename: row[7],
        # old_opened_on: row[8],
        registrated_on: row[9],
        last_updated_on: row[10],
        revision_count: row[11],
        file_encoding_id: row[12],
        charset_id: row[13],
        # NOTE: row[14],
        created_at: row[9].presence || DEFAULT_DATE,
        updated_at: row[10].presence || DEFAULT_DATE
      }

      if row[14].present?
        buf2 << {
          workfile_id: row[0],
          memo: row[14],
          created_at: row[9].presence || DEFAULT_DATE,
          updated_at: row[10].presence || DEFAULT_DATE
        }
      end
    end
    Workfile.insert_all(buf)
    update_serial('workfiles')
    Shinonome::WorkfileSecret.insert_all(buf2)
    update_serial('workfile_secrets')
  end

  def load_receipts(filename)
    receipts = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      receipts << {
        id: row[0],
        title_kana: row[1],
        title: row[2],
        subtitle_kana: row[3],
        subtitle: row[4],
        collection_kana: row[5],
        collection: row[6],
        original_title: row[7],
        kana_type_id: row[8],
        first_appearance: row[9],
        memo: row[10],
        note: row[11],
        work_status_id: row[12],
        started_on: row[13],
        copyright_flag: row[14],
        last_name_kana: row[15],
        last_name: row[16],
        last_name_en: row[17],
        first_name_kana: row[18],
        first_name: row[19],
        first_name_en: row[20],
        person_note: row[21],
        worker_kana: row[22],
        worker_name: row[23],
        email: row[24],
        url: row[25],
        original_book_title: row[26],
        publisher: row[27],
        first_pubdate: row[28],
        input_edition: row[29],
        original_book_title2: row[30],
        publisher2: row[31],
        first_pubdate2: row[32],
        person_id: row[33],
        worker_id: row[34],
        created_at: row[35],
        register_status: row[36],
        original_book_note: row[37]
      }
    end
    Receipt.insert_all(receipts)
    update_serial('receipts')
  end

  def load_proofreads(filename)
    buf = []
    path = File.join(@data_dir, filename)
    CSV.foreach(path, headers: true) do |row|
      next if row[1] == '3030' # データ欠番

      buf << {
        id: row[0],
        work_id: row[1],
        work_copy: row[2],
        work_print: row[3],
        proof_edition: row[4],
        workfile: row[5],
        address: row[6],
        memo: row[7],
        worker_id: row[8],
        worker_kana: row[9],
        worker_name: row[10],
        email: row[11],
        url: row[12],
        person_id: row[13],
        assign_status: row[14],
        order_status: row[15],
        created_at: row[16],
        updated_at: row[16]
      }
    end
    Proofread.insert_all(buf)
    update_serial('proofreads')
  end

  # utils

  def truncate_table(*table_names)
    names = table_names.join(',')
    ApplicationRecord.connection.execute("TRUNCATE TABLE #{names}")
  end

  def update_serial(table_name)
    ApplicationRecord.connection.reset_pk_sequence!(table_name)
  end

  def force_lf(str)
    str.gsub("\r\n", "\n").gsub("\r", "\n")
  end

  # rubocop:enable Rails/SkipsModelValidations
end
