# frozen_string_literal: true

class CreateBookPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :book_people do |t|
      t.bigint :book_id, null: false
      t.bigint :person_id, null: false
      t.bigint :role_id, null: false

      t.timestamps
    end
  end
end
