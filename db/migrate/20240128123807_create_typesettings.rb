# frozen_string_literal: true

class CreateTypesettings < ActiveRecord::Migration[7.1]
  def change
    create_table :typesettings do |t|
      t.text :original_filename
      t.text :content
      t.text :comment
      t.references :user, null: false, foreign_key: true
      t.references :work, null: true, foreign_key: true

      t.timestamps
    end
  end
end
