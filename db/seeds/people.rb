# frozen_string_literal: true

Person.connection.execute('TRUNCATE TABLE people;')
2000.times do |i|
  n = i + 1
  name = Gimei.name
  born_date = Faker::Date.between(from: '1800-01-01', to: '1900-01-01')
  died_year = born_date.year + 30 + rand(30)
  died_date = Faker::Date.in_date_period(year: died_year)
  desc = ''.dup
  (3..8).to_a.sample.times{ desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
  Person.create!(last_name: name.last.kanji,
                 last_name_kana: name.last.hiragana,
                 first_name: name.first.kanji,
                 first_name_kana: name.first.hiragana,
                 born_on: born_date,
                 died_on: died_date,
                 copyright_flag: rand(100) >= 90,
                 email: "aozora+person#{n}@example.com",
                 url: "https://www.aozora.gr.jp/dummy/people/#{n}",
                 description: desc,
                 note: "備考#{n}",
                 sortkey: name.last.hiragana,
                 sortkey2: name.first.hiragana)
end
