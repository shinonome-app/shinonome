# frozen_string_literal: true

class CreateBookSites < ActiveRecord::Migration[6.1]
  def change
    create_table :book_sites do |t|
      t.bigint :book_id
      t.bigint :site_id

      t.timestamps
    end
  end
end
