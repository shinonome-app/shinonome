# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                    :integer          not null, primary key
#  title                 :text             not null
#  title_kana            :text
#  subtitle              :text
#  subtitle_kana         :text
#  collection            :text
#  collection_kana       :text
#  original_title        :text
#  kana_type_id          :integer          not null
#  author_display_name   :text
#  first_appearance      :text
#  description           :text
#  description_person_id :integer
#  book_status_id        :integer          not null
#  started_on            :date             not null
#  copyright_flag        :boolean          not null
#  note                  :text
#  orig_text             :text
#  user_id               :integer          not null
#  update_flag           :integer
#  sortkey               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_books_on_book_status_id  (book_status_id)
#  index_books_on_kana_type_id    (kana_type_id)
#  index_books_on_user_id         (user_id)
#

FactoryBot.define do
  factory :book do
    user
    kana_type
    book_status
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
    update_flag { 1 }
    sortkey { 'MyText' }
  end
end
