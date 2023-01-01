# frozen_string_literal: true

class CreateProofreads < ActiveRecord::Migration[6.1]
  def change
    create_table :proofreads do |t|
      t.references :work, foreign_key: true, null: false
      t.integer :work_copy, null: false, default: 0
      t.integer :work_print, null: false, default: 0
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
      t.integer :assign_status, null: false
      t.integer :order_status, null: false
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
