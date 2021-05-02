# == Schema Information
#
# Table name: books
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean
#  description           :text
#  first_appearance      :text
#  note                  :text
#  orig_text             :text
#  orig_title            :text
#  sortkey               :text
#  started_on            :date
#  status                :text
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text
#  title_kana            :text
#  update_flag           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description_person_id :bigint
#  kana_type_id          :bigint
#  user_id               :bigint
#
require 'rails_helper'

RSpec.describe Book, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
