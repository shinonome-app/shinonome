# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                  :bigint           not null, primary key
#  collection          :text
#  collection_kana     :text
#  copyright_flag      :boolean
#  created_on          :date
#  email               :text
#  first_appearance    :text
#  first_name          :text
#  first_name_en       :text
#  first_name_kana     :text
#  first_pubdate       :text
#  first_pubdate2      :text
#  input_edition       :text
#  last_name           :text
#  last_name_en        :text
#  last_name_kana      :text
#  memo                :text
#  note                :text
#  original_book_name  :text
#  original_book_name2 :text
#  original_book_note  :text
#  original_title      :text
#  person_note         :text
#  publisher           :text
#  publisher2          :text
#  register_status     :integer
#  started_on          :text
#  status              :text
#  subtitle            :text
#  subtitle_kana       :text
#  title               :text
#  title_kana          :text
#  url                 :text
#  worker_kana         :text
#  worker_name         :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  kana_type_id        :text
#  person_id           :text
#  worker_id           :text
#
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
