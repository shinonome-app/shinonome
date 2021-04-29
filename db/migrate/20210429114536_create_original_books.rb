class CreateOriginalBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :original_books do |t|
      t.integer :book_id
      t.text :title
      t.text :publisher
      t.text :first_pubyear
      t.text :input_edition
      t.text :proof_edition
      t.text :booktype_name
      t.text :note

      t.timestamps
    end
  end
end
