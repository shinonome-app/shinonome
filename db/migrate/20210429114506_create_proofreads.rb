class CreateProofreads < ActiveRecord::Migration[6.1]
  def change
    create_table :proofreads do |t|
      t.integer :book_id
      t.text :book_copy
      t.text :book_print
      t.text :refbook
      t.integer :bookfile_id
      t.text :address
      t.text :memo
      t.integer :worker_id
      t.text :woker_kana
      t.text :worker_name
      t.text :email
      t.text :url
      t.integer :person_id
      t.text :sts1
      t.text :sts2

      t.timestamps
    end
  end
end
