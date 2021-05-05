# frozen_string_literal: true

Book.connection.execute('TRUNCATE TABLE books;')
Book.connection.execute('TRUNCATE TABLE book_workers;')
Book.connection.execute('TRUNCATE TABLE book_people;')
selected_workers = Worker.order(:id).limit(10)
1000.times do |i|
  n = i + 1
  desc = ''.dup
  (3..8).to_a.sample.times { desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
  worker = selected_workers.sample
  author = Person.all.sample
  book = Book.create!(
    title_kana: "さくひん#{n}",
    title: "作品#{n}",
    subtitle_kana: "ふくだい#{n}",
    subtitle: "副題#{n}",
    collection_kana: "さくひんしゅう#{n}",
    collection: "作品集#{n}",
    original_title: rand(100) > 90 ? "Awesome Piece No. #{n}" : nil,
    kana_type_id: [1, 2, 3, 4].sample,
    first_appearance: "初出#{n}",
    description: desc,
    book_status: BookStatus.all.sample,
    started_on: Time.zone.parse('2021-05-05'),
    copyright_flag: rand(100) <= 90,
    user: User.all.sample
  )
  bw = book.book_workers.build(worker: worker, worker_role_id: 1)
  bw.save!
  bp = book.book_people.build(person: author, role_id: 1)
  bp.save!
  next unless rand(10) >= 9

  translator = Person.all.sample
  bp2 = book.book_people.build(person: translator, role_id: 2)
  bp2.save!
end
