# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :text
#  copyright_flag  :boolean          default(FALSE), not null
#  description     :text
#  died_on         :text
#  email           :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text             not null
#  last_name_en    :text
#  last_name_kana  :text             not null
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :bigint
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :person do
    transient do
      name { Gimei.name }
      day_death { Faker::Date.birthday(min_age: 70, max_age: 200) }
    end

    last_name { name.last.kanji }
    last_name_kana { name.last.hiragana }
    last_name_en { name.last.romaji }
    first_name { name.first.kanji }
    first_name_kana { name.first.hiragana }
    first_name_en { name.first.romaji }
    died_on { day_death }
    born_on { day_death + (365 * 20) + rand(365 * 60) }
    copyright_flag { [true, false].sample }
    sequence(:email) { |i| "sample-person-#{i}@example.com" }
    sequence(:url) { |i| "https://sample#{i}.example.com" }
    description { Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
    basename { nil }
    updated_by { rand(1..10) }
    sortkey { name.last.hiragana }
    sortkey2 { name.first.hiragana }
    input_count { 1 }
    publish_count { 1 }

    after(:build) do |person|
      create(:person_secret, person:)
    end
  end
end
