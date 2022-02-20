# frozen_string_literal: true

class CreateWorktypes < ActiveRecord::Migration[6.1]
  def change
    create_table :worktypes do |t|
      t.text :name, null: false

      t.timestamps
    end
  end
end
