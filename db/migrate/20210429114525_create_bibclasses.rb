class CreateBibclasses < ActiveRecord::Migration[6.1]
  def change
    create_table :bibclasses do |t|
      t.bigint :book_id
      t.text :name
      t.text :num
      t.text :note

      t.timestamps
    end
  end
end
