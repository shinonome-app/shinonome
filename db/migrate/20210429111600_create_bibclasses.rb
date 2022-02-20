# frozen_string_literal: true

class CreateBibclasses < ActiveRecord::Migration[6.1]
  def change
    create_table :bibclasses do |t|
      t.bigint :work_id, null: false
      t.text :name, null: false
      t.text :num, null: false
      t.text :note

      t.timestamps
    end
  end
end
