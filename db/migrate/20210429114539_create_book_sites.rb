class CreateBookSites < ActiveRecord::Migration[6.1]
  def change
    create_table :book_sites do |t|
      t.integer :book_id
      t.integer :site_id

      t.timestamps
    end
  end
end
