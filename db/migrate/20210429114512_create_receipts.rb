class CreateReceipts < ActiveRecord::Migration[6.1]
  def change
    create_table :receipts do |t|
      t.text :sakuhinmeiyomi
      t.text :sakuhinmei
      t.text :fukudaiyomi
      t.text :fukudai
      t.text :sakuhinshuumeiyomi
      t.text :sakuhinshuumei
      t.text :gendai
      t.text :kana
      t.text :shoshutu
      t.text :memo
      t.text :bikou
      t.text :status
      t.text :statusdate
      t.boolean :copyright
      t.text :seiyomi
      t.text :sei
      t.text :seieiji
      t.text :meiyomi
      t.text :mei
      t.text :meieiji
      t.text :jbikou
      t.text :seimeiyomi
      t.text :seimei
      t.text :email
      t.text :url
      t.text :bookname
      t.text :publisher
      t.text :firstversion
      t.text :versioninput
      t.text :bookname2
      t.text :publisher2
      t.text :firstversion2
      t.text :personid
      t.text :workerid
      t.date :insdate
      t.integer :sts
      t.text :bkbikou

      t.timestamps
    end
  end
end
