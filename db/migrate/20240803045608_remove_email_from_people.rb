# frozen_string_literal: true

class RemoveEmailFromPeople < ActiveRecord::Migration[7.1]
  def change
    remove_column :people, :email, :text
  end
end
