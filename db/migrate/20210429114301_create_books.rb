class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.text :title
      t.text :title_kana
      t.text :subtitle
      t.text :subtitle_kana
      t.text :collection
      t.text :collection_kana
      t.text :orig_title
      t.integer :kana_type_id
      t.text :author_display_name
      t.text :first_appearance
      t.text :description
      t.integer :description_person_id
      t.text :status
      t.date :started_on
      t.boolean :copyright_flag
      t.text :note
      t.text :orig_text
      t.integer :user_id
      t.integer :update_flag
      t.text :sortkey

      t.timestamps
    end
  end
end
