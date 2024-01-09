class AddIndexToWorkPeopleWorkAndRole < ActiveRecord::Migration[7.1]
  def change
    add_index :work_people, [:work_id, :role_id]
  end
end
