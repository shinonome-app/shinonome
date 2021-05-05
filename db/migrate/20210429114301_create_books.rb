# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.text :title, null: false
      t.text :title_kana
      t.text :subtitle
      t.text :subtitle_kana
      t.text :collection
      t.text :collection_kana
      t.text :original_title
      t.bigint :kana_type_id
      t.text :author_display_name
      t.text :first_appearance
      t.text :description
      t.bigint :description_person_id
      t.bigint :book_status_id, null: false
      t.date :started_on, null: false
      t.boolean :copyright_flag, null: false
      t.text :note
      t.text :orig_text
      t.bigint :user_id
      t.integer :update_flag
      t.text :sortkey

      t.timestamps
    end
  end
end
