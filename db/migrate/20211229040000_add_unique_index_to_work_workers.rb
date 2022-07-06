# frozen_string_literal: true

class AddUniqueIndexToWorkWorkers < ActiveRecord::Migration[6.1]
  def change
    add_index :work_workers, %i[work_id worker_id worker_role_id], unique: true
  end
end
