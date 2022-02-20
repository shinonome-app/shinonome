# frozen_string_literal: true

class CreateWorkerSecrets < ActiveRecord::Migration[7.0]
  def change
    create_table :worker_secrets do |t|
      t.references :worker, null: false
      t.text :email, null: false
      t.text :url
      t.text :note
      t.references :user, null: true

      t.timestamps
    end
  end
end
