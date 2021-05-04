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
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
