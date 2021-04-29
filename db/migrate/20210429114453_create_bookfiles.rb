class CreateBookfiles < ActiveRecord::Migration[6.1]
  def change
    create_table :bookfiles do |t|
      t.integer :book_id
      t.integer :filetype_id
      t.integer :compresstype_id
      t.integer :filesize
      t.integer :user_id
      t.text :url
      t.text :filename
      t.date :opened_on
      t.integer :fixnum
      t.integer :file_encoding_id
      t.integer :charset_id
      t.text :note

      t.timestamps
    end
  end
end
