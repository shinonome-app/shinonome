# frozen_string_literal: true

# == Schema Information
#
# Table name: person_secrets
#
#  id         :bigint           not null, primary key
#  memo       :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint
#
# Indexes
#
#  index_person_secrets_on_person_id  (person_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
FactoryBot.define do
  factory :person_secret, class: 'Shinonome::PersonSecret' do
    memo { Faker::Lorem.sentence(word_count: 5, random_words_to_add: 15) }
    person
  end
end
