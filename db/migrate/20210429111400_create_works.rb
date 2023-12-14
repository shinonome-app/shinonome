# frozen_string_literal: true

class CreateWorks < ActiveRecord::Migration[6.1]
  def change
    create_table :works do |t|
      t.text :title, null: false
      t.text :title_kana
      t.text :subtitle
      t.text :subtitle_kana
      t.text :collection
      t.text :collection_kana
      t.text :original_title
      t.references :kana_type, foreign_key: true, null: false
      t.text :author_display_name
      t.text :first_appearance
      t.text :description
      t.bigint :description_person_id
      t.references :work_status, foreign_key: true, null: false
      t.date :started_on, null: false
      t.boolean :copyright_flag, null: false, default: false
      t.text :note
      t.text :orig_text
      t.references :user, null: false
      t.text :sortkey

      t.timestamps
    end
  end
end
