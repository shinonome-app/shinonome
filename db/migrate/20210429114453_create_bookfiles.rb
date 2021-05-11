# frozen_string_literal: true

class CreateBookfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :bookfiles do |t|
      t.references :book, foreign_key: true, null: false
      t.references :filetype, foreign_key: true, null: false
      t.references :compresstype, foreign_key: true, null: false
      t.integer :filesize
      t.bigint :user_id
      t.text :url
      t.text :filename, null: false
      t.date :opened_on
      t.integer :revision_count
      t.references :file_encoding, foreign_key: true, null: false
      t.references :charset, foreign_key: true, null: false
      t.text :note

      t.timestamps
    end
  end
end
