# frozen_string_literal: true

class CreatePersonSites < ActiveRecord::Migration[6.1]
  def change
    create_table :person_sites do |t|
      t.references :person, foreign_key: true, null: false
      t.references :site, foreign_key: true, null: false

      t.timestamps
    end
  end
end
