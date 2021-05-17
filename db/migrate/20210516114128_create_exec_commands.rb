# frozen_string_literal: true

class CreateExecCommands < ActiveRecord::Migration[6.1]
  def change
    create_table :exec_commands do |t|
      t.text :command
      t.bigint :user_id
      t.integer :separator

      t.timestamps
    end
  end
end
