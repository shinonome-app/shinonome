# frozen_string_literal: true

class CreateProofreads < ActiveRecord::Migration[6.1]
  def change
    create_table :proofreads do |t|
      t.references :work, foreign_key: true, null: false
      t.text :work_copy
      t.text :work_print
      t.text :proof_edition
      t.bigint :workfile
      t.text :address
      t.text :memo
      t.bigint :worker_id
      t.text :worker_kana
      t.text :worker_name
      t.text :email
      t.text :url
      t.references :person, foreign_key: true, null: false
      t.text :assign_status
      t.text :order_status

      t.timestamps
    end
  end
end
