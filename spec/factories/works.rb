# frozen_string_literal: true

# == Schema Information
#
# Table name: works
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean          not null
#  description           :text
#  first_appearance      :text
#  note                  :text
#  orig_text             :text
#  original_title        :text
#  sortkey               :text
#  started_on            :date             not null
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text             not null
#  title_kana            :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description_person_id :bigint
#  kana_type_id          :bigint           not null
#  user_id               :bigint           not null
#  work_status_id        :bigint           not null
#
# Indexes
#
#  index_works_on_kana_type_id    (kana_type_id)
#  index_works_on_user_id         (user_id)
#  index_works_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (kana_type_id => kana_types.id)
#  fk_rails_...  (work_status_id => work_statuses.id)
#

FactoryBot.define do
  factory :work do
    transient do
      n { rand(10000) }
    end

    user
    kana_type_id { (1..4).to_a.sample }
    work_status_id { 1 }
    title { "作品#{n}" }
    title_kana { "さくひん#{n}" }
    subtitle { "副題#{n}" }
    subtitle_kana { "ふくだい#{n}" }
    collection { nil }
    collection_kana { nil }
    original_title { rand(100) > 90 ? "Awesome Piece No. #{n}" : nil }
    author_display_name { 'DummyAuthorDisplayName' }
    first_appearance { "初出#{n}" }
    description { Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
    description_person_id { 1 }
    started_on { Faker::Date.birthday(min_age: 0, max_age: 3) }
    copyright_flag { false }
    note { Faker::Lorem.sentence(word_count: 10, random_words_to_add: 15) }
    orig_text { nil }
    sortkey { "さくひん#{n}" }

    trait :teihon do
      original_books { [association(:original_book)] }
    end
  end
end
