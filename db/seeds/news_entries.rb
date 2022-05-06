# frozen_string_literal: true

NewsEntry.connection.execute('TRUNCATE TABLE news_entries;')

news_entries = (1..200).map do
  publish_date = Faker::Date.between(from: '1997-08-01', to: '2022-05-01')
  title = Faker::Lorem.sentence(word_count: 5, random_words_to_add: 10).chop
  body = ''.dup
  (3..30).to_a.sample.times do
    body << Faker::Lorem.sentence(word_count: 20, random_words_to_add: 30)
  end

  body.gsub!('。') { rand(100) > 70 ? "。\n" : "。\n\n" }

  {
    body: body,
    flag: rand(100) > 80,
    published_on: publish_date,
    title: title,
    created_at: Time.current,
    updated_at: Time.current
  }
end

sorted_news_entries = news_entries.sort_by { |x| x[:published_on] }

NewsEntry.insert_all(sorted_news_entries)
