# frozen_string_literal: true

class CreateBookWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :book_workers do |t|
      t.references :book, foreign_key: true, null: false
      t.references :worker, foreign_key: true, null: false
      t.references :worker_role, foreign_key: true, null: false

      t.timestamps
    end
  end
end
