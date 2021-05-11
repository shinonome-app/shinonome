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

ActiveRecord::Schema.define(version: 2021_05_09_025330) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "base_people", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_base_people_on_person_id"
  end

  create_table "bibclasses", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.text "name", null: false
    t.text "num", null: false
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_people", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "person_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_people_on_book_id"
    t.index ["person_id"], name: "index_book_people_on_person_id"
    t.index ["role_id"], name: "index_book_people_on_role_id"
  end

  create_table "book_sites", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "site_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_sites_on_book_id"
    t.index ["site_id"], name: "index_book_sites_on_site_id"
  end

  create_table "book_statuses", force: :cascade do |t|
    t.text "name", null: false
    t.integer "sort_order", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_workers", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "worker_id", null: false
    t.bigint "worker_role_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_book_workers_on_book_id"
    t.index ["worker_id"], name: "index_book_workers_on_worker_id"
    t.index ["worker_role_id"], name: "index_book_workers_on_worker_role_id"
  end

  create_table "bookfiles", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.bigint "filetype_id", null: false
    t.bigint "compresstype_id", null: false
    t.integer "filesize"
    t.bigint "user_id"
    t.text "url"
    t.text "filename", null: false
    t.date "opened_on"
    t.integer "revision_count"
    t.bigint "file_encoding_id", null: false
    t.bigint "charset_id", null: false
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_bookfiles_on_book_id"
    t.index ["charset_id"], name: "index_bookfiles_on_charset_id"
    t.index ["compresstype_id"], name: "index_bookfiles_on_compresstype_id"
    t.index ["file_encoding_id"], name: "index_bookfiles_on_file_encoding_id"
    t.index ["filetype_id"], name: "index_bookfiles_on_filetype_id"
  end

  create_table "books", force: :cascade do |t|
    t.text "title", null: false
    t.text "title_kana"
    t.text "subtitle"
    t.text "subtitle_kana"
    t.text "collection"
    t.text "collection_kana"
    t.text "original_title"
    t.bigint "kana_type_id", null: false
    t.text "author_display_name"
    t.text "first_appearance"
    t.text "description"
    t.bigint "description_person_id"
    t.bigint "book_status_id", null: false
    t.date "started_on", null: false
    t.boolean "copyright_flag", null: false
    t.text "note"
    t.text "orig_text"
    t.bigint "user_id", null: false
    t.integer "update_flag"
    t.text "sortkey"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_status_id"], name: "index_books_on_book_status_id"
    t.index ["kana_type_id"], name: "index_books_on_kana_type_id"
    t.index ["user_id"], name: "index_books_on_user_id"
  end

  create_table "booktypes", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "charsets", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "compresstypes", force: :cascade do |t|
    t.text "name"
    t.text "extension"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "file_encodings", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "filetypes", force: :cascade do |t|
    t.text "name"
    t.text "extension"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "kana_types", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "news", force: :cascade do |t|
    t.date "published_on"
    t.text "title", null: false
    t.text "body", null: false
    t.boolean "flag", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "original_books", force: :cascade do |t|
    t.bigint "book_id"
    t.text "title", null: false
    t.text "publisher"
    t.text "first_pubdate"
    t.text "input_edition"
    t.text "proof_edition"
    t.bigint "booktype_id"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_original_books_on_book_id"
    t.index ["booktype_id"], name: "index_original_books_on_booktype_id"
  end

  create_table "people", force: :cascade do |t|
    t.text "last_name", null: false
    t.text "last_name_kana", null: false
    t.text "last_name_en"
    t.text "first_name"
    t.text "first_name_kana"
    t.text "first_name_en"
    t.date "born_on"
    t.date "died_on"
    t.boolean "copyright_flag", null: false
    t.text "email"
    t.text "url"
    t.text "description"
    t.bigint "note_user_id"
    t.text "basename"
    t.text "note"
    t.text "updated_by"
    t.text "sortkey"
    t.text "sortkey2"
    t.integer "input_count"
    t.integer "publish_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "person_sites", force: :cascade do |t|
    t.bigint "person_id", null: false
    t.bigint "site_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["person_id"], name: "index_person_sites_on_person_id"
    t.index ["site_id"], name: "index_person_sites_on_site_id"
  end

  create_table "proofreads", force: :cascade do |t|
    t.bigint "book_id", null: false
    t.text "book_copy"
    t.text "book_print"
    t.text "proof_edition"
    t.bigint "bookfile"
    t.text "address"
    t.text "memo"
    t.bigint "worker_id"
    t.text "worker_kana"
    t.text "worker_name"
    t.text "email"
    t.text "url"
    t.bigint "person_id", null: false
    t.text "assign_status"
    t.text "order_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["book_id"], name: "index_proofreads_on_book_id"
    t.index ["person_id"], name: "index_proofreads_on_person_id"
  end

  create_table "receipts", force: :cascade do |t|
    t.text "title_kana", null: false
    t.text "title", null: false
    t.text "subtitle_kana"
    t.text "subtitle"
    t.text "collection_kana"
    t.text "collection"
    t.text "original_title"
    t.text "kana_type_id"
    t.text "first_appearance"
    t.text "memo"
    t.text "note"
    t.text "status"
    t.text "started_on"
    t.boolean "copyright_flag", null: false
    t.text "last_name_kana", null: false
    t.text "last_name", null: false
    t.text "last_name_en"
    t.text "first_name_kana"
    t.text "first_name"
    t.text "first_name_en"
    t.text "person_note"
    t.text "worker_kana", null: false
    t.text "worker_name", null: false
    t.text "email", null: false
    t.text "url"
    t.text "original_book_title", null: false
    t.text "publisher", null: false
    t.text "first_pubdate", null: false
    t.text "input_edition", null: false
    t.text "original_book_title2"
    t.text "publisher2"
    t.text "first_pubdate2"
    t.text "person_id"
    t.text "worker_id"
    t.date "created_on"
    t.integer "register_status", default: 0
    t.text "original_book_note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sites", force: :cascade do |t|
    t.text "name", null: false
    t.text "url", null: false
    t.text "owner_name"
    t.text "email"
    t.text "note"
    t.bigint "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "worker_roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workers", force: :cascade do |t|
    t.text "name", null: false
    t.text "name_kana", null: false
    t.text "email", null: false
    t.text "url"
    t.text "note"
    t.bigint "user_id"
    t.text "sortkey"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_workers_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "base_people", "people"
  add_foreign_key "book_people", "books"
  add_foreign_key "book_people", "people"
  add_foreign_key "book_people", "roles"
  add_foreign_key "book_sites", "books"
  add_foreign_key "book_sites", "sites"
  add_foreign_key "book_workers", "books"
  add_foreign_key "book_workers", "worker_roles"
  add_foreign_key "book_workers", "workers"
  add_foreign_key "bookfiles", "books"
  add_foreign_key "bookfiles", "charsets"
  add_foreign_key "bookfiles", "compresstypes"
  add_foreign_key "bookfiles", "file_encodings"
  add_foreign_key "bookfiles", "filetypes"
  add_foreign_key "books", "book_statuses"
  add_foreign_key "books", "kana_types"
  add_foreign_key "books", "users"
  add_foreign_key "original_books", "books"
  add_foreign_key "original_books", "booktypes"
  add_foreign_key "person_sites", "people"
  add_foreign_key "person_sites", "sites"
  add_foreign_key "proofreads", "books"
  add_foreign_key "proofreads", "people"
end
