class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.text :last_name
      t.text :last_name_kana
      t.text :last_name_en
      t.text :first_name
      t.text :first_name_kana
      t.text :first_name_en
      t.date :born_on
      t.date :died_on
      t.boolean :copyright_flag
      t.text :email
      t.text :url
      t.text :description
      t.bigint :note_user_id
      t.text :basename
      t.text :note
      t.text :updated_by
      t.text :sortkey
      t.text :sortkey2
      t.integer :input_count
      t.integer :publish_count

      t.timestamps
    end
  end
end
