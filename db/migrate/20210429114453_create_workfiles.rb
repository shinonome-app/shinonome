# frozen_string_literal: true

class CreateWorkfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :workfiles do |t|
      t.references :work, foreign_key: true, null: false
      t.references :filetype, foreign_key: true, null: false
      t.references :compresstype, foreign_key: true, null: false
      t.integer :filesize
      t.bigint :user_id
      t.text :url
      t.text :filename
      t.date :opened_on
      t.integer :revision_count
      t.references :file_encoding, foreign_key: true, null: false
      t.references :charset, foreign_key: true, null: false
      t.date :registrated_on
      t.date :last_updated_on
      t.text :note

      t.timestamps
    end
  end
end
