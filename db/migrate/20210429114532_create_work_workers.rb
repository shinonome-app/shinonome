# frozen_string_literal: true

class CreateWorkWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :work_workers do |t|
      t.references :work, foreign_key: true, null: false
      t.references :worker, foreign_key: true, null: false
      t.references :worker_role, foreign_key: true, null: false

      t.timestamps
    end
  end
end
