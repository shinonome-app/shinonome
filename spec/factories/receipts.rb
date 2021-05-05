# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean          not null
#  created_on           :date
#  email                :text             not null
#  first_appearance     :text
#  first_name           :text
#  first_name_en        :text
#  first_name_kana      :text
#  first_pubdate        :text             not null
#  first_pubdate2       :text
#  input_edition        :text             not null
#  last_name            :text             not null
#  last_name_en         :text
#  last_name_kana       :text             not null
#  memo                 :text
#  note                 :text
#  original_book_note   :text
#  original_book_title  :text             not null
#  original_book_title2 :text
#  original_title       :text
#  person_note          :text
#  publisher            :text             not null
#  publisher2           :text
#  register_status      :integer          default(0)
#  started_on           :text
#  status               :text
#  subtitle             :text
#  subtitle_kana        :text
#  title                :text             not null
#  title_kana           :text             not null
#  url                  :text
#  worker_kana          :text             not null
#  worker_name          :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  kana_type_id         :text
#  person_id            :text
#  worker_id            :text
#
FactoryBot.define do
  factory :receipt do
    title_kana { 'MyText' }
    title { 'MyText' }
    subtitle_kana { 'MyText' }
    subtitle { 'MyText' }
    collection_kana { 'MyText' }
    collection { 'MyText' }
    original_title { 'MyText' }
    kana { 'MyText' }
    first_appearance { 'MyText' }
    memo { 'MyText' }
    note { 'MyText' }
    status { 'MyText' }
    started_on { 'MyText' }
    copyright_flag { false }
    last_name_kana { 'MyText' }
    sei { 'MyText' }
    last_name_en { 'MyText' }
    first_name_kana { 'MyText' }
    mei { 'MyText' }
    first_name_en { 'MyText' }
    person_note { 'MyText' }
    worker_kana { 'MyText' }
    worker_name { 'MyText' }
    email { 'MyText' }
    url { 'MyText' }
    original_book_title { 'MyText' }
    publisher { 'MyText' }
    first_pubdate { 'MyText' }
    input_edition { 'MyText' }
    original_book_title2 { 'MyText' }
    publisher2 { 'MyText' }
    first_pubdate2 { 'MyText' }
    person_id { 'MyText' }
    worker_id { 'MyText' }
    created_on { '2021-04-29' }
    register_status { 1 }
    original_book_note { 'MyText' }
  end
end
