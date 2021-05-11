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
#  kana_type_id          :bigint           not null
#  user_id               :bigint           not null
#
# Indexes
#
#  index_books_on_book_status_id  (book_status_id)
#  index_books_on_kana_type_id    (kana_type_id)
#  index_books_on_user_id         (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_status_id => book_statuses.id)
#  fk_rails_...  (kana_type_id => kana_types.id)
#  fk_rails_...  (user_id => users.id)
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
