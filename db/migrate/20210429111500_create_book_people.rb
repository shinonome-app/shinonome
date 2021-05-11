# frozen_string_literal: true

class CreateBookPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :book_people do |t|
      t.references :book, foreign_key: true, null: false
      t.references :person, foreign_key: true, null: false
      t.references :role, foreign_key: true, null: false

      t.timestamps
    end
  end
end
