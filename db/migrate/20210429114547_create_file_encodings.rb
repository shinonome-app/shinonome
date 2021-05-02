# frozen_string_literal: true

class CreateFileEncodings < ActiveRecord::Migration[6.1]
  def change
    create_table :file_encodings do |t|
      t.text :name

      t.timestamps
    end
  end
end
