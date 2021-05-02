class CreateBookPeople < ActiveRecord::Migration[6.1]
  def change
    create_table :book_people do |t|
      t.bigint :book_id
      t.bigint :person_id
      t.bigint :role_id

      t.timestamps
    end
  end
end
