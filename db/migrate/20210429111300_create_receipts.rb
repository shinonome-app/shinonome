# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.text :title_kana, null: false
      t.text :title, null: false
      t.text :subtitle_kana
      t.text :subtitle
      t.text :collection_kana
      t.text :collection
      t.text :original_title
      t.text :kana_type_id
      t.text :first_appearance
      t.text :memo
      t.text :note
      t.boolean :copyright_flag, null: false
      t.text :last_name_kana, null: false
      t.text :last_name, null: false
      t.text :last_name_en
      t.text :first_name_kana
      t.text :first_name
      t.text :first_name_en
      t.text :person_note
      t.text :worker_kana, null: false
      t.text :worker_name, null: false
      t.text :email, null: false
      t.text :url
      t.text :original_book_title, null: false
      t.text :publisher, null: false
      t.text :first_pubdate, null: false
      t.text :input_edition, null: false
      t.text :original_book_title2
      t.text :publisher2
      t.text :first_pubdate2
      t.bigint :person_id
      t.bigint :worker_id
      t.bigint :work_id
      t.integer :register_status, default: 0, null: false
      t.text :original_book_note
      t.references :work_status, foreign_key: true, null: false
      t.date :started_on, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
