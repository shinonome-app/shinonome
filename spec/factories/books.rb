# frozen_string_literal: true

# == Schema Information
#
# Table name: books
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
#  update_flag           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  book_status_id        :bigint           not null
#  description_person_id :bigint
#  kana_type_id          :bigint
#  user_id               :bigint
#
FactoryBot.define do
  factory :book do
    title { 'MyText' }
    title_kana { 'MyText' }
    subtitle { 'MyText' }
    subtitle_kana { 'MyText' }
    collection { 'MyText' }
    collection_kana { 'MyText' }
    original_title { 'MyText' }
    kana_type_id { 1 }
    author_display_name { 'MyText' }
    first_appearance { 'MyText' }
    description { 'MyText' }
    description_person_id { 1 }
    status { 'MyText' }
    started_on { '2021-04-29' }
    copyright_flag { false }
    note { 'MyText' }
    orig_text { 'MyText' }
    updated_at { '2021-04-29 20:43:01' }
    user_id { 1 }
    update_flag { 1 }
    sortkey { 'MyText' }
  end
end
