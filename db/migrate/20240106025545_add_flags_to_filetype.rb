# frozen_string_literal: true

class AddFlagsToFiletype < ActiveRecord::Migration[7.0]
  def change
    change_table :filetypes, bulk: true do |t|
      t.boolean :is_html, default: false, null: false
      t.boolean :is_text, default: false, null: false
      t.boolean :is_rtxt, default: false, null: false
    end
  end
end
