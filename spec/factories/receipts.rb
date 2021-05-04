# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean
#  created_on           :date
#  email                :text
#  first_appearance     :text
#  first_name           :text
#  first_name_en        :text
#  first_name_kana      :text
#  first_pubdate        :text
#  first_pubdate2       :text
#  input_edition        :text
#  last_name            :text
#  last_name_en         :text
#  last_name_kana       :text
#  memo                 :text
#  note                 :text
#  original_book_note   :text
#  original_book_title  :text
#  original_book_title2 :text
#  original_title       :text
#  person_note          :text
#  publisher            :text
#  publisher2           :text
#  register_status      :integer
#  started_on           :text
#  status               :text
#  subtitle             :text
#  subtitle_kana        :text
#  title                :text
#  title_kana           :text
#  url                  :text
#  worker_kana          :text
#  worker_name          :text
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
