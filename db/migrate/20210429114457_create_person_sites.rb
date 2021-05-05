# frozen_string_literal: true

class CreatePersonSites < ActiveRecord::Migration[6.1]
  def change
    create_table :person_sites do |t|
      t.bigint :person_id, null: false
      t.bigint :site_id, null: false

      t.timestamps
    end
  end
end
