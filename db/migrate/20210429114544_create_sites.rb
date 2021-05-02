# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites do |t|
      t.text :name
      t.text :url
      t.text :owner_name
      t.text :email
      t.text :note
      t.integer :updated_by

      t.timestamps
    end
  end
end
