# frozen_string_literal: true

class CreateOriginalBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :original_books do |t|
      t.bigint :book_id
      t.text :title
      t.text :publisher
      t.text :first_pubdate
      t.text :input_edition
      t.text :proof_edition
      t.bigint :booktype_id
      t.text :note

      t.timestamps
    end
  end
end
