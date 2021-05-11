# frozen_string_literal: true

class CreateCompresstypes < ActiveRecord::Migration[6.1]
  def change
    create_table :compresstypes do |t|
      t.text :name
      t.text :extension

      t.timestamps
    end
  end
end
