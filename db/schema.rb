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

ActiveRecord::Schema.define(version: 2021_04_29_114559) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "base_people", force: :cascade do |t|
    t.integer "person_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bibclasses", force: :cascade do |t|
    t.integer "book_id"
    t.text "name"
    t.text "num"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_people", force: :cascade do |t|
    t.integer "book_id"
    t.integer "person_id"
    t.integer "role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_sites", force: :cascade do |t|
    t.integer "book_id"
    t.integer "site_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "book_workers", force: :cascade do |t|
    t.integer "book_id"
    t.integer "woker_id"
    t.integer "worker_role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "bookfiles", force: :cascade do |t|
    t.integer "book_id"
    t.integer "filetype_id"
    t.integer "compresstype_id"
    t.integer "filesize"
    t.integer "user_id"
    t.text "url"
    t.text "filename"
    t.date "opened_on"
    t.integer "fixnum"
    t.integer "file_encoding_id"
    t.integer "charset_id"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "books", force: :cascade do |t|
    t.text "title"
    t.text "title_kana"
    t.text "subtitle"
    t.text "subtitle_kana"
    t.text "collection"
    t.text "collection_kana"
    t.text "orig_title"
    t.integer "kana_type_id"
    t.text "author_display_name"
    t.text "first_appearance"
    t.text "description"
    t.integer "description_person_id"
    t.text "status"
    t.date "started_on"
    t.boolean "copyright_flag"
    t.text "note"
    t.text "orig_text"
    t.integer "user_id"
    t.integer "update_flag"
    t.text "sortkey"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "charsets", force: :cascade do |t|
    t.text "name"
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
    t.text "title"
    t.text "body"
    t.boolean "flag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "original_books", force: :cascade do |t|
    t.integer "book_id"
    t.text "title"
    t.text "publisher"
    t.text "first_pubyear"
    t.text "input_edition"
    t.text "proof_edition"
    t.text "booktype_name"
    t.text "note"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "people", force: :cascade do |t|
    t.text "last_name"
    t.text "last_name_kana"
    t.text "last_name_en"
    t.text "first_name"
    t.text "first_name_kana"
    t.text "first_name_en"
    t.date "born_on"
    t.date "died_on"
    t.boolean "copyright_flag"
    t.text "email"
    t.text "url"
    t.text "description"
    t.integer "note_user_id"
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
    t.integer "person_id"
    t.integer "site_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "proofreads", force: :cascade do |t|
    t.integer "book_id"
    t.text "book_copy"
    t.text "book_print"
    t.text "refbook"
    t.integer "bookfile_id"
    t.text "address"
    t.text "memo"
    t.integer "worker_id"
    t.text "woker_kana"
    t.text "worker_name"
    t.text "email"
    t.text "url"
    t.integer "person_id"
    t.text "sts1"
    t.text "sts2"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.text "sakuhinmeiyomi"
    t.text "sakuhinmei"
    t.text "fukudaiyomi"
    t.text "fukudai"
    t.text "sakuhinshuumeiyomi"
    t.text "sakuhinshuumei"
    t.text "gendai"
    t.text "kana"
    t.text "shoshutu"
    t.text "memo"
    t.text "bikou"
    t.text "status"
    t.text "statusdate"
    t.boolean "copyright"
    t.text "seiyomi"
    t.text "sei"
    t.text "seieiji"
    t.text "meiyomi"
    t.text "mei"
    t.text "meieiji"
    t.text "jbikou"
    t.text "seimeiyomi"
    t.text "seimei"
    t.text "email"
    t.text "url"
    t.text "bookname"
    t.text "publisher"
    t.text "firstversion"
    t.text "versioninput"
    t.text "bookname2"
    t.text "publisher2"
    t.text "firstversion2"
    t.text "personid"
    t.text "workerid"
    t.date "insdate"
    t.integer "sts"
    t.text "bkbikou"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sites", force: :cascade do |t|
    t.text "name"
    t.text "url"
    t.text "owner_name"
    t.text "email"
    t.text "note"
    t.integer "updated_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "worker_roles", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "workers", force: :cascade do |t|
    t.text "name"
    t.text "name_kana"
    t.text "email"
    t.text "url"
    t.text "note"
    t.integer "user_id"
    t.text "sortkey"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
