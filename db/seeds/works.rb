# frozen_string_literal: true

# Work.connection.execute('TRUNCATE TABLE works;')
# Work.connection.execute('TRUNCATE TABLE work_workers;')
# Work.connection.execute('TRUNCATE TABLE work_people;')
# Work.connection.execute('TRUNCATE TABLE bibclasses;')
# Work.connection.execute('TRUNCATE TABLE original_books;')

## Works
selected_workers = Worker.order(:id).limit(10)
person_id_list = Person.all.pluck(:id)
person_a_id_list = Person.where('sortkey ~ ?', '^あ').all.pluck(:id)
work_status_id_list = WorkStatus.all.pluck(:id)
user_id_list = Shinonome::User.all.pluck(:id)

FIRST_CHAR = 'あいうえおかきくけこさしすせそたちつてとなにぬねのはひふへほまみむめもやゆよらりるれろわをん★'

works = (1..5000).map do |n|
  desc = ''.dup
  (2..8).to_a.sample.times { desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
  note = ''.dup
  (0..4).to_a.sample.times { note << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }

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
    work_status_id: rand(100) < 80 ? 1 : work_status_id_list.sample,
    started_on: started,
    note: note,
    copyright_flag: rand(100) <= 90,
    sortkey: "#{ch}さくひん#{n}",
    user_id: user_id_list.sample,
    created_at: created,
    updated_at: Time.current
  }
end
Work.insert_all(works.sort_by { |b| b[:created_at] })

## WorkWorkers
work_id_status_list = Work.all.pluck(:id, :work_status_id)
work_id_list = Work.all.pluck(:id)

work_workers = work_id_list.map do |n|
  worker = selected_workers.sample

  {
    work_id: n,
    worker_id: worker.id,
    worker_role_id: 1,
    created_at: Time.current,
    updated_at: Time.current
  }
end

work_id_status_list.each do |n, status|
  next unless [1, 9, 10].include?(status)

  worker = selected_workers.sample

  work_workers << {
    work_id: n,
    worker_id: worker.id,
    worker_role_id: 2,
    created_at: Time.current,
    updated_at: Time.current
  }
end

WorkWorker.insert_all(work_workers)

## WorkPeople
work_people = work_id_list.map do |n|
  author_id = if n % 10 == 0
                person_a_id_list[0,2].sample
              else
                person_id_list.sample
              end

  {
    work_id: n,
    person_id: author_id,
    role_id: 1,
    created_at: Time.current,
    updated_at: Time.current
  }
end

work_id_list.each do |n|
  next unless rand(10) >= 9

  translator_id = person_id_list.sample

  work_people << {
    work_id: n,
    person_id: translator_id,
    role_id: 2,
    created_at: Time.current,
    updated_at: Time.current
  }
end

WorkPerson.insert_all(work_people)

## Bibclasses
bibclasses = work_id_list.filter_map do |n|
  if rand(10) >= 3
    {
      work_id: n,
      name: 'NDC',
      num: %w[913 914 911 121 289 596 K913].sample,
      created_at: Time.current,
      updated_at: Time.current
    }
  end
end

Bibclass.insert_all(bibclasses)

## OriginalBooks
original_books = work_id_list.map do |n|
  {
    work_id: n,
    title: "底本名#{n}",
    first_pubdate: "初版発行年月日#{n}",
    input_edition: "入力使用版#{n}",
    proof_edition: "校正使用版#{n}",
    publisher: "底本出版社#{n}",
    note: "底本備考#{n}",
    worktype_id: 1,
    created_at: Time.current,
    updated_at: Time.current
  }
end

work_id_list.each do |n|
  next unless rand(10) >= 5

  original_books << {
    work_id: n,
    title: "底本の親本名#{n}",
    first_pubdate: "初版発行年月日#{n}",
    input_edition: "入力使用版#{n}",
    proof_edition: "校正使用版#{n}",
    publisher: "親本出版社#{n}",
    note: "底本の親本備考#{n}",
    worktype_id: 2,
    created_at: Time.current,
    updated_at: Time.current
  }
end

OriginalBook.insert_all(original_books)
