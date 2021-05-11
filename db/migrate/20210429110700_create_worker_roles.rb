# frozen_string_literal: true

class CreateWorkerRoles < ActiveRecord::Migration[6.1]
  def change
    create_table :worker_roles do |t|
      t.text :name

      t.timestamps
    end
  end
end
