# frozen_string_literal: true

class CreateNews < ActiveRecord::Migration[6.1]
  def change
    create_table :news do |t|
      t.date :published_on
      t.text :title
      t.text :body
      t.boolean :flag

      t.timestamps
    end
  end
end
