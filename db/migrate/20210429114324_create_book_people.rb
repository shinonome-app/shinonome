class CreateBookPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :book_people do |t|
      t.integer :book_id
      t.integer :person_id
      t.integer :role_id

      t.timestamps
    end
  end
end
