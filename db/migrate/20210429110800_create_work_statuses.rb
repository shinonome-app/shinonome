# frozen_string_literal: true

class CreateWorkStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :work_statuses do |t|
      t.text :name, null: false
      t.integer :sort_order, null: false

      t.timestamps
    end
  end
end
