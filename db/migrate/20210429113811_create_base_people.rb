class CreateBasePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :base_people do |t|
      t.integer :person_id

      t.timestamps
    end
  end
end
