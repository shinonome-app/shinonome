# frozen_string_literal: true

# Person.connection.execute('TRUNCATE TABLE people;')
people = (1..2000).map do |n|
  name = Gimei.name
  born_date = Faker::Date.between(from: '1800-01-01', to: '1900-01-01')
  died_year = born_date.year + 30 + rand(30)
  died_date = Faker::Date.in_date_period(year: died_year)
  desc = ''.dup
  (3..8).to_a.sample.times do
    desc << Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15)
  end

  {
    last_name: name.last.kanji,
    last_name_kana: name.last.hiragana,
    last_name_en: name.last.romaji,
    first_name: name.first.kanji,
    first_name_kana: name.first.hiragana,
    first_name_en: name.first.romaji,
    born_on: born_date,
    died_on: died_date,
    copyright_flag: rand(100) >= 90,
    email: "shinonome+person#{n}@example.com",
    url: "https://shononome.example.com/dummy/people/#{n}",
    description: desc,
    note: "備考#{n}",
    sortkey: name.last.hiragana,
    sortkey2: name.first.hiragana,
    created_at: Time.current,
    updated_at: Time.current
  }
end

Person.insert_all(people)

base_people = (1..100).map do
  x = rand(1..2000)
  y = rand(1..2000)

  if x == y
    redo
  elsif x > y
    x, y = y, x
  end

  {
    person_id: y,
    original_person_id: x
  }
end

BasePerson.insert_all(base_people)
