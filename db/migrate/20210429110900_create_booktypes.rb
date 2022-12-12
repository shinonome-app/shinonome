# frozen_string_literal: true

class CreateBooktypes < ActiveRecord::Migration[6.1]
  def change
    create_table :booktypes do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
