class CreateCharsets < ActiveRecord::Migration[6.1]
  def change
    create_table :charsets do |t|
      t.text :name

      t.timestamps
    end
  end
end
