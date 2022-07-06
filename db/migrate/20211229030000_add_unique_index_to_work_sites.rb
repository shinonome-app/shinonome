# frozen_string_literal: true

class AddUniqueIndexToWorkSites < ActiveRecord::Migration[6.1]
  def change
    add_index :work_sites, %i[work_id site_id], unique: true
  end
end
