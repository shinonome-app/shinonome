# frozen_string_literal: true

class RemoveSecretColumns < ActiveRecord::Migration[7.1]
  def change
    remove_column :sites, :email, :text
    remove_column :sites, :owner_name, :text
    remove_column :sites, :note, :text

    remove_column :original_books, :note, :text

    remove_column :people, :note_user_id, :bigint
    remove_column :people, :note, :text

    remove_column :works, :orig_text, :text

    remove_column :workfiles, :opened_on, :date
    remove_column :workfiles, :user_id, :bigint
    remove_column :workfiles, :note, :text
  end
end
