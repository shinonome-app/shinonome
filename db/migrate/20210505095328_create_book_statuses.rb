# frozen_string_literal: true

class CreateBookStatuses < ActiveRecord::Migration[6.1]
  def change
    create_table :book_statuses do |t|
      t.string :name, null: false
      t.integer :sort_order, null: false

      t.timestamps
    end
  end
end
