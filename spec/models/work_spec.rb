# frozen_string_literal: true

# == Schema Information
#
# Table name: works
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
#  work_status_id        :integer          not null
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
#  index_works_on_work_status_id  (work_status_id)
#  index_works_on_kana_type_id    (kana_type_id)
#  index_works_on_user_id         (user_id)
#

require 'rails_helper'

RSpec.describe Work, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
