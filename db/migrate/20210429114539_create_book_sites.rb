# frozen_string_literal: true

class CreateBookSites < ActiveRecord::Migration[6.1]
  def change
    create_table :book_sites do |t|
      t.references :book, foreign_key: true, null: false
      t.references :site, foreign_key: true, null: false

      t.timestamps
    end
  end
end
