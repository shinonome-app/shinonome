# frozen_string_literal: true

# Receipt.connection.execute('TRUNCATE TABLE receipts;')
person_list = Person.all.pluck(:id, :first_name, :first_name_kana, :last_name, :last_name_kana)
selected_workers = Worker.order(:id).limit(100)

receipts = (1..100).map do |n|
  desc = ''.dup
  (3..8).to_a.sample.times { desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
  worker = selected_workers.sample
  person = person_list.sample

  {
    title_kana: "さくひん#{n}",
    title: "作品#{n}",
    subtitle_kana: "ふくだい#{n}",
    subtitle: "副題#{n}",
    collection_kana: "さくひんしゅう#{n}",
    collection: "作品集#{n}",
    original_title: rand(100) > 90 ? "Awesome Piece No. #{n}" : nil,
    kana_type_id: [1, 2, 3, 4].sample,
    first_appearance: "初出#{n}",
    memo: desc,
    note: "備考#{n}",
    status: [0, 1].sample,
    started_on: Time.zone.parse('2021-05-01'),
    copyright_flag: [0, 1].sample,
    first_name: person[1],
    first_name_kana: person[2],
    first_name_en: '',
    last_name: person[3],
    last_name_kana: person[4],
    last_name_en: '',
    person_note: "人物に関する備考#{n}",
    worker_kana: worker.name_kana,
    worker_name: worker.name,
    email: "shinonome+input#{n}@example.com",
    url: "https//shinonome.example.com/inputs/#{n}",
    original_work_title: "底本名#{n}",
    publisher: "底本出版社#{n}",
    first_pubdate: Time.zone.parse('1980-02-03'),
    input_edition: "入力使用版#{n}",
    original_work_title2: "底本の親本#{n}",
    publisher2: "親本出版社#{n}",
    first_pubdate2: Time.zone.parse('1950-02-03'),
    person_id: person[0],
    worker_id: worker.id,
    created_on: Time.zone.parse('2021-05-01'),
    register_status: [0, 1].sample,
    original_work_note: "底本に関する備考#{n}",
    created_at: Time.current,
    updated_at: Time.current
  }
end

Receipt.insert_all(receipts)
