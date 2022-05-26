# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean          not null
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
#  started_on           :date             not null
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
#  work_status_id       :bigint           not null
#  worker_id            :text
#
# Indexes
#
#  index_receipts_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_status_id => work_statuses.id)
#

FactoryBot.define do
  factory :receipt do
    title_kana { 'さくひんそのいち' }
    title { '作品その一' }
    subtitle_kana { 'ふくだいそのに' }
    subtitle { '副題その二' }
    original_title { '原題その３' }
    kana_type_id { 1 }
    first_appearance { 'MyText' }
    started_on { '2022-05-10' }
    copyright_flag { false }
    last_name_kana { 'MyText' }
    last_name_en { 'MyText' }
    last_name { 'MyText' }
    first_name_kana { 'MyText' }
    first_name_en { 'MyText' }
    first_name { 'MyText' }
    person_note { 'MyText' }
    worker_kana { 'MyText' }
    worker_name { 'MyText' }
    email { 'sample@example.com' }
    original_book_title { 'MyText' }
    publisher { 'MyText' }
    first_pubdate { 'MyText' }
    input_edition { 'MyText' }
    original_book_title2 { 'MyText' }
    publisher2 { 'MyText' }
    first_pubdate2 { 'MyText' }
    person_id { 10 }
    worker_id { 11 }
    register_status { 1 }
    original_book_note { 'MyText' }
    work_status
  end
end
