class CreateBookWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :book_workers do |t|
      t.integer :book_id
      t.integer :woker_id
      t.integer :worker_role_id

      t.timestamps
    end
  end
end
