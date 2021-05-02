class CreateWorkers < ActiveRecord::Migration[6.1]
  def change
    create_table :workers do |t|
      t.text :name
      t.text :name_kana
      t.text :email
      t.text :url
      t.text :note
      t.bigint :user_id
      t.text :sortkey

      t.timestamps
    end
  end
end
