# frozen_string_literal: true

class CreateWorkSites < ActiveRecord::Migration[6.1]
  def change
    create_table :work_sites do |t|
      t.references :work, foreign_key: true, null: false
      t.references :site, foreign_key: true, null: false

      t.timestamps
    end
  end
end
