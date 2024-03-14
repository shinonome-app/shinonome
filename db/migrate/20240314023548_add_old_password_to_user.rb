# frozen_string_literal: true

class AddOldPasswordToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :old_password, :string
  end
end
