# frozen_string_literal: true

class CreateFiletypes < ActiveRecord::Migration[6.1]
  def change
    create_table :filetypes do |t|
      t.text :name
      t.text :extension

      t.timestamps
    end
  end
end
