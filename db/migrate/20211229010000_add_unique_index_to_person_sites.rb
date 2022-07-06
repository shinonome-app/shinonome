# frozen_string_literal: true

class AddUniqueIndexToPersonSites < ActiveRecord::Migration[6.1]
  def change
    add_index :person_sites, %i[person_id site_id], unique: true
  end
end
