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
#  published_on          :date
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
    user
    kana_type_id { 1 }
    work_status_id { 1 }
    title { 'MyText' }
    title_kana { 'MyText' }
    subtitle { 'MyText' }
    subtitle_kana { 'MyText' }
    collection { 'MyText' }
    collection_kana { 'MyText' }
    original_title { 'MyText' }
    author_display_name { 'MyText' }
    first_appearance { 'MyText' }
    description { 'MyText' }
    description_person_id { 1 }
    started_on { '2021-04-29' }
    copyright_flag { false }
    note { 'MyText' }
    orig_text { 'MyText' }
    updated_at { '2021-04-29 20:43:01' }
    sortkey { 'MyText' }

    trait :teihon do
      original_book
    end
  end
end
