# frozen_string_literal: true

Book.connection.execute('TRUNCATE TABLE books;')
Book.connection.execute('TRUNCATE TABLE book_workers;')
Book.connection.execute('TRUNCATE TABLE book_people;')
selected_workers = Worker.order(:id).limit(10)
person_id_list = Person.all.pluck(:id)
book_status_id_list = BookStatus.all.pluck(:id)
user_id_list = User.all.pluck(:id)

FIRST_CHAR = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん★'

books = (1..5000).map do |n|
  desc = ''.dup
  (3..8).to_a.sample.times { desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }

  ch = FIRST_CHAR.chars.sample
  created = Faker::Time.between(from: Time.zone.parse('1997-01-01'), to: Time.zone.parse('2021-05-05'))
  started = Faker::Time.between(from: Time.zone.parse('1998-01-01'), to: Time.zone.parse('2021-05-05'))
  started = created if created > started

  {
    title_kana: "#{ch}さくひん#{n}",
    title: "#{ch}作品#{n}",
    subtitle_kana: "ふくだい#{n}",
    subtitle: "副題#{n}",
    collection_kana: "さくひんしゅう#{n}",
    collection: "作品集#{n}",
    original_title: rand(100) > 90 ? "Awesome Piece No. #{n}" : nil,
    kana_type_id: [1, 2, 3, 4].sample,
    first_appearance: "初出#{n}",
    description: desc,
    book_status_id: book_status_id_list.sample,
    started_on: started,
    copyright_flag: rand(100) <= 90,
    sortkey: "#{ch}さくひん#{n}",
    user_id: user_id_list.sample,
    created_at: created,
    updated_at: Time.current
  }
end
Book.insert_all(books.sort_by { |b| b[:created_at] })

book_id_list = Book.all.pluck(:id)

book_workers = book_id_list.map do |n|
  worker = selected_workers.sample

  {
    book_id: n,
    worker_id: worker.id,
    worker_role_id: 1,
    created_at: Time.current,
    updated_at: Time.current
  }
end

BookWorker.insert_all(book_workers)

book_people = book_id_list.map do |n|
  author_id = person_id_list.sample

  {
    book_id: n,
    person_id: author_id,
    role_id: 1,
    created_at: Time.current,
    updated_at: Time.current
  }
end

book_id_list.each do |n|
  next unless rand(10) >= 9

  translator_id = person_id_list.sample

  book_people << {
    book_id: n,
    person_id: translator_id,
    role_id: 2,
    created_at: Time.current,
    updated_at: Time.current
  }
end

BookPerson.insert_all(book_people)
