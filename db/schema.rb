# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_505_095_328) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'base_people', force: :cascade do |t|
    t.bigint 'person_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'bibclasses', force: :cascade do |t|
    t.bigint 'book_id'
    t.text 'name'
    t.text 'num'
    t.text 'note'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'book_people', force: :cascade do |t|
    t.bigint 'book_id', null: false
    t.bigint 'person_id', null: false
    t.bigint 'role_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'book_sites', force: :cascade do |t|
    t.bigint 'book_id'
    t.bigint 'site_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'book_statuses', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'sort_order', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'book_workers', force: :cascade do |t|
    t.bigint 'book_id', null: false
    t.bigint 'worker_id', null: false
    t.bigint 'worker_role_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'bookfiles', force: :cascade do |t|
    t.bigint 'book_id'
    t.bigint 'filetype_id'
    t.bigint 'compresstype_id'
    t.integer 'filesize'
    t.bigint 'user_id'
    t.text 'url'
    t.text 'filename'
    t.date 'opened_on'
    t.integer 'fixnum'
    t.bigint 'file_encoding_id'
    t.bigint 'charset_id'
    t.text 'note'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'books', force: :cascade do |t|
    t.text 'title', null: false
    t.text 'title_kana'
    t.text 'subtitle'
    t.text 'subtitle_kana'
    t.text 'collection'
    t.text 'collection_kana'
    t.text 'original_title'
    t.bigint 'kana_type_id'
    t.text 'author_display_name'
    t.text 'first_appearance'
    t.text 'description'
    t.bigint 'description_person_id'
    t.bigint 'book_status_id', null: false
    t.date 'started_on', null: false
    t.boolean 'copyright_flag', null: false
    t.text 'note'
    t.text 'orig_text'
    t.bigint 'user_id'
    t.integer 'update_flag'
    t.text 'sortkey'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'charsets', force: :cascade do |t|
    t.text 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'compresstypes', force: :cascade do |t|
    t.text 'name'
    t.text 'extension'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'file_encodings', force: :cascade do |t|
    t.text 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'filetypes', force: :cascade do |t|
    t.text 'name'
    t.text 'extension'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'kana_types', force: :cascade do |t|
    t.text 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'news', force: :cascade do |t|
    t.date 'published_on'
    t.text 'title'
    t.text 'body'
    t.boolean 'flag'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'original_books', force: :cascade do |t|
    t.bigint 'book_id'
    t.text 'title'
    t.text 'publisher'
    t.text 'first_pubdate'
    t.text 'input_edition'
    t.text 'proof_edition'
    t.text 'booktype_name'
    t.text 'note'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'people', force: :cascade do |t|
    t.text 'last_name'
    t.text 'last_name_kana'
    t.text 'last_name_en'
    t.text 'first_name'
    t.text 'first_name_kana'
    t.text 'first_name_en'
    t.date 'born_on'
    t.date 'died_on'
    t.boolean 'copyright_flag'
    t.text 'email'
    t.text 'url'
    t.text 'description'
    t.bigint 'note_user_id'
    t.text 'basename'
    t.text 'note'
    t.text 'updated_by'
    t.text 'sortkey'
    t.text 'sortkey2'
    t.integer 'input_count'
    t.integer 'publish_count'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'person_sites', force: :cascade do |t|
    t.bigint 'person_id', null: false
    t.bigint 'site_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'proofreads', force: :cascade do |t|
    t.bigint 'book_id'
    t.text 'book_copy'
    t.text 'book_print'
    t.text 'proof_edition'
    t.bigint 'bookfile_id'
    t.text 'address'
    t.text 'memo'
    t.bigint 'worker_id'
    t.text 'worker_kana'
    t.text 'worker_name'
    t.text 'email'
    t.text 'url'
    t.bigint 'person_id'
    t.text 'assign_status'
    t.text 'order_status'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'receipts', force: :cascade do |t|
    t.text 'title_kana', null: false
    t.text 'title', null: false
    t.text 'subtitle_kana'
    t.text 'subtitle'
    t.text 'collection_kana'
    t.text 'collection'
    t.text 'original_title'
    t.text 'kana_type_id'
    t.text 'first_appearance'
    t.text 'memo'
    t.text 'note'
    t.text 'status'
    t.text 'started_on'
    t.boolean 'copyright_flag', null: false
    t.text 'last_name_kana', null: false
    t.text 'last_name', null: false
    t.text 'last_name_en'
    t.text 'first_name_kana'
    t.text 'first_name'
    t.text 'first_name_en'
    t.text 'person_note'
    t.text 'worker_kana', null: false
    t.text 'worker_name', null: false
    t.text 'email', null: false
    t.text 'url'
    t.text 'original_book_title', null: false
    t.text 'publisher', null: false
    t.text 'first_pubdate', null: false
    t.text 'input_edition', null: false
    t.text 'original_book_title2'
    t.text 'publisher2'
    t.text 'first_pubdate2'
    t.text 'person_id'
    t.text 'worker_id'
    t.date 'created_on'
    t.integer 'register_status', default: 0
    t.text 'original_book_note'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'roles', force: :cascade do |t|
    t.text 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'sites', force: :cascade do |t|
    t.text 'name', null: false
    t.text 'url', null: false
    t.text 'owner_name'
    t.text 'email'
    t.text 'note'
    t.integer 'updated_by'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'username', default: '', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['username'], name: 'index_users_on_username', unique: true
  end

  create_table 'worker_roles', force: :cascade do |t|
    t.text 'name'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'workers', force: :cascade do |t|
    t.text 'name'
    t.text 'name_kana'
    t.text 'email'
    t.text 'url'
    t.text 'note'
    t.bigint 'user_id'
    t.text 'sortkey'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end
end
