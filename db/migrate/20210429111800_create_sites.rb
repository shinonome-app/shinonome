# frozen_string_literal: true

class CreateSites < ActiveRecord::Migration[6.1]
  def change
    create_table :sites do |t|
      t.text :name, null: false
      t.text :url, null: false
      t.text :owner_name
      t.text :email
      t.text :note
      t.bigint :updated_by

      t.timestamps
    end
  end
end
