# frozen_string_literal: true

class CreateOriginalWorks < ActiveRecord::Migration[6.1]
  def change
    create_table :original_works do |t|
      t.references :work, foreign_key: true
      t.text :title, null: false
      t.text :publisher
      t.text :first_pubdate
      t.text :input_edition
      t.text :proof_edition
      t.references :worktype, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
