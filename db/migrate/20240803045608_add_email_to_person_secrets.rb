class AddEmailToPersonSecrets < ActiveRecord::Migration[7.1]
  def change
    add_column :person_secrets, :email, :text
    remove_column :people, :email, :text
  end
end
