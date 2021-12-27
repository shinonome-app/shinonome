# frozen_string_literal: true
# == Schema Information
#
# Table name: receipts
#
#  id                   :integer          not null, primary key
#  title_kana           :text             not null
#  title                :text             not null
#  subtitle_kana        :text
#  subtitle             :text
#  collection_kana      :text
#  collection           :text
#  original_title       :text
#  kana_type_id         :text
#  first_appearance     :text
#  memo                 :text
#  note                 :text
#  status               :text
#  started_on           :text
#  copyright_flag       :boolean          not null
#  last_name_kana       :text             not null
#  last_name            :text             not null
#  last_name_en         :text
#  first_name_kana      :text
#  first_name           :text
#  first_name_en        :text
#  person_note          :text
#  worker_kana          :text             not null
#  worker_name          :text             not null
#  email                :text             not null
#  url                  :text
#  original_book_title  :text             not null
#  publisher            :text             not null
#  first_pubdate        :text             not null
#  input_edition        :text             not null
#  original_book_title2 :text
#  publisher2           :text
#  first_pubdate2       :text
#  person_id            :text
#  worker_id            :text
#  created_on           :date
#  register_status      :integer          default("0")
#  original_book_note   :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

class Receipt < ApplicationRecord
end
