# frozen_string_literal: true

class CreateWorkPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :work_people do |t|
      t.references :work, foreign_key: true, null: false
      t.references :person, foreign_key: true, null: false
      t.references :role, foreign_key: true, null: false

      t.timestamps
    end
  end
end
