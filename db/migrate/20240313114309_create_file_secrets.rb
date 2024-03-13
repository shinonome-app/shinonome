# frozen_string_literal: true

class CreateFileSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :workfile_secrets do |t|
      t.text :memo
      t.references :workfile

      t.timestamps
    end

    create_table :work_secrets do |t|
      t.text :memo
      t.references :work

      t.timestamps
    end
  end
end
