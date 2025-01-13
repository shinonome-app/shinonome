# frozen_string_literal: true

class CreateEditableContents < ActiveRecord::Migration[7.2]
  def change
    create_table :editable_contents do |t|
      t.string :area_name
      t.string :key
      t.text :value

      t.timestamps

      t.index [:area_name, :key]
    end
  end
end
