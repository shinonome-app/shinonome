# frozen_string_literal: true

class CreateBookWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :book_workers do |t|
      t.bigint :book_id, null: false
      t.bigint :worker_id, null: false
      t.bigint :worker_role_id, null: false

      t.timestamps
    end
  end
end
