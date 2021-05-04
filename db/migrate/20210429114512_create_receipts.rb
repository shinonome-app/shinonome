# frozen_string_literal: true

class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.text :title_kana
      t.text :title
      t.text :subtitle_kana
      t.text :subtitle
      t.text :collection_kana
      t.text :collection
      t.text :original_title
      t.text :kana_type_id
      t.text :first_appearance
      t.text :memo
      t.text :note
      t.text :status
      t.text :started_on
      t.boolean :copyright_flag
      t.text :last_name_kana
      t.text :last_name
      t.text :last_name_en
      t.text :first_name_kana
      t.text :first_name
      t.text :first_name_en
      t.text :person_note
      t.text :worker_kana
      t.text :worker_name
      t.text :email
      t.text :url
      t.text :original_book_name
      t.text :publisher
      t.text :first_pubdate
      t.text :input_edition
      t.text :original_book_name2
      t.text :publisher2
      t.text :first_pubdate2
      t.text :person_id
      t.text :worker_id
      t.date :created_on
      t.integer :register_status
      t.text :original_book_note

      t.timestamps
    end
  end
end
