# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean          default(FALSE), not null
#  deleted_at           :datetime
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
#  register_status      :integer          default("non_ordered"), not null
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
#  person_id            :bigint
#  work_id              :bigint
#  work_status_id       :bigint           not null
#  worker_id            :bigint
#
# Indexes
#
#  index_receipts_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_status_id => work_statuses.id)
#

require 'rails_helper'

RSpec.describe Receipt do
  pending "add some examples to (or delete) #{__FILE__}"
end
