# frozen_string_literal: true

class CreateNewsEntries < ActiveRecord::Migration[6.1]
  def change
    create_table :news_entries do |t|
      t.date :published_on
      t.text :title, null: false
      t.text :body, null: false
      t.boolean :flag, null: false

      t.timestamps
    end
  end
end
