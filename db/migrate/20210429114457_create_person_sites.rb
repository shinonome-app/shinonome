class CreatePersonSites < ActiveRecord::Migration[6.1]
  def change
    create_table :person_sites do |t|
      t.integer :person_id
      t.integer :site_id

      t.timestamps
    end
  end
end
