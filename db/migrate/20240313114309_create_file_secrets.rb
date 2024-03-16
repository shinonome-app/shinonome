# frozen_string_literal: true

class CreateFileSecrets < ActiveRecord::Migration[7.1]
  def change
    create_table :workfile_secrets do |t|
      t.text :memo, null: false, default: ''
      t.references :workfile

      t.timestamps
    end

    create_table :work_secrets do |t|
      t.text :orig_text, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.references :work

      t.timestamps
    end

    create_table :person_secrets do |t|
      t.text :memo, null: false, default: ''
      t.references :person

      t.timestamps
    end

    create_table :original_book_secrets do |t|
      t.text :memo, null: false, default: ''
      t.references :original_book

      t.timestamps
    end

    create_table :site_secrets do |t|
      t.text :email, null: false, default: ''
      t.text :owner_name, null: false, default: ''
      t.text :memo, null: false, default: ''
      t.references :site

      t.timestamps
    end
  end
end
