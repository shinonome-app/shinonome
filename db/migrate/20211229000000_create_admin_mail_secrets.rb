# frozen_string_literal: true

class CreateAdminMailSecrets < ActiveRecord::Migration[7.0]
  def change
    create_table :admin_mail_secrets do |t|
      t.references :worker, null: false
      t.text :email, null: false
      t.text :subject, null: false
      t.text :body, null: false
      t.integer :cc_flag

      t.timestamps
    end
  end
end
