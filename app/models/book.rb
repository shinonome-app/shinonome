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
  has_many :book_sites
  has_many :sites, through: :book_sites
  has_many :book_people
  has_many :people, through: :book_people
  has_many :book_workers
  has_many :workers, through: :book_workers

  has_one :bibclass

  belongs_to :user
  belongs_to :kana_type
  has_many :description_people
end
