# frozen_string_literal: true

class AddIndexToWorkPeopleWorkAndRole < ActiveRecord::Migration[7.1]
  def change
    add_index :work_people, %i[work_id role_id]
  end
end
