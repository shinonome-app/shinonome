class CreateBookWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :book_workers do |t|
      t.bigint :book_id
      t.bigint :worker_id
      t.bigint :worker_role_id

      t.timestamps
    end
  end
end
