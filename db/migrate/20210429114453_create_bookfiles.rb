# frozen_string_literal: true

class CreateBookfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :bookfiles do |t|
      t.bigint :book_id, null: false
      t.bigint :filetype_id
      t.bigint :compresstype_id
      t.integer :filesize
      t.bigint :user_id
      t.text :url
      t.text :filename, null: false
      t.date :opened_on
      t.integer :fixnum
      t.bigint :file_encoding_id
      t.bigint :charset_id
      t.text :note

      t.timestamps
    end
  end
end
