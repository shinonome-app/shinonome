# frozen_string_literal: true

class CreatePersonSites < ActiveRecord::Migration[6.1]
  def change
    create_table :person_sites do |t|
      t.bigint :person_id
      t.bigint :site_id

      t.timestamps
    end
  end
end
