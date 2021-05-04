# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                 :bigint           not null, primary key
#  note              :text
#  original_book_note            :text
#  original_book_name           :text
#  original_book_name2          :text
#  copyright_flag          :boolean
#  email              :text
#  first_pubdate       :text
#  first_pubdate2      :text
#  subtitle            :text
#  subtitle_kana        :text
#  original_title             :text
#  created_on            :date
#  person_note             :text
#  kana               :text
#  mei                :text
#  first_name_en            :text
#  first_name_kana            :text
#  memo               :text
#  person_id           :text
#  publisher          :text
#  publisher2         :text
#  title         :text
#  title_kana     :text
#  collection     :text
#  collection_kana :text
#  sei                :text
#  last_name_en            :text
#  worker_name             :text
#  worker_kana         :text
#  last_name_kana            :text
#  first_appearance           :text
#  status             :text
#  started_on         :text
#  register_status                :integer
#  url                :text
#  input_edition       :text
#  worker_id           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
    original_book_name { 'MyText' }
    publisher { 'MyText' }
    first_pubdate { 'MyText' }
    input_edition { 'MyText' }
    original_book_name2 { 'MyText' }
    publisher2 { 'MyText' }
    first_pubdate2 { 'MyText' }
    person_id { 'MyText' }
    worker_id { 'MyText' }
    created_on { '2021-04-29' }
    register_status { 1 }
    original_book_note { 'MyText' }
  end
end
