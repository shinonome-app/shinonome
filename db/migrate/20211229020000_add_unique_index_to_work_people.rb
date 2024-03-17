# frozen_string_literal: true

class AddUniqueIndexToWorkPeople < ActiveRecord::Migration[6.1]
  def change
    add_index :work_people, %i[work_id person_id role_id], unique: true
    add_index :work_people, %i[work_id person_id]
  end
end
