# frozen_string_literal: true

class CreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.text :name, null: false
      t.text :name_kana, null: false
      t.text :sortkey

      t.timestamps
    end
  end
end
