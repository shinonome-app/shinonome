# == Schema Information
#
# Table name: books
#
#  id                    :bigint           not null, primary key
#  title                 :text
#  title_kana            :text
#  subtitle              :text
#  subtitle_kana         :text
#  collection            :text
#  collection_kana       :text
#  orig_title            :text
#  kana_type_id          :integer
#  author_display_name   :text
#  first_appearance      :text
#  description           :text
#  description_person_id :integer
#  status                :text
#  started_on            :date
#  copyright_flag        :boolean
#  note                  :text
#  orig_text             :text
#  user_id               :integer
#  update_flag           :integer
#  sortkey               :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Book < ApplicationRecord
end
