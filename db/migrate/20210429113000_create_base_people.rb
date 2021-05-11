# frozen_string_literal: true

class CreateBasePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :base_people do |t|
      t.references :person, foreign_key: true, null: false

      t.timestamps
    end
  end
end
