# frozen_string_literal: true

class CreateKanaTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :kana_types do |t|
      t.text :name

      t.timestamps
    end
  end
end
