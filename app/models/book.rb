# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean          not null
#  description           :text
#  first_appearance      :text
#  note                  :text
#  orig_text             :text
#  original_title        :text
#  sortkey               :text
#  started_on            :date             not null
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text             not null
#  title_kana            :text
#  update_flag           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  book_status_id        :bigint           not null
#  description_person_id :bigint
#  kana_type_id          :bigint
#  user_id               :bigint
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
  belongs_to :book_status
  has_many :description_people

  def author_text
    book_people.where(role_id: 1).map { |a| a.person.name }.join(', ')
  end

  def translator_text
    book_people.where(role_id: 2).map { |a| a.person.name }.join(', ')
  end
end
