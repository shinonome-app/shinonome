# frozen_string_literal: true

# == Schema Information
#
# Table name: books
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
#  book_status_id        :integer          not null
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
#  index_books_on_book_status_id  (book_status_id)
#  index_books_on_kana_type_id    (kana_type_id)
#  index_books_on_user_id         (user_id)
#

# 作品
class Book < ApplicationRecord
  has_many :book_sites, dependent: :destroy
  has_many :sites, through: :book_sites
  has_many :book_people, dependent: :destroy
  has_many :people, through: :book_people
  has_many :book_workers, dependent: :destroy
  has_many :workers, through: :book_workers
  has_many :bookfiles, dependent: :destroy

  has_many :bibclasses, dependent: :destroy
  has_many :original_books, dependent: :destroy

  belongs_to :user
  belongs_to :kana_type
  belongs_to :book_status

  scope :with_year_and_status, ->(year, status) { where('extract(year from created_at) = ? AND book_status_id = ?', year, status) }

  scope :with_creator_firstchar, lambda { |char|
    if char == 'その他'
      joins(:people).where('people.sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      joins(:people).where('people.sortkey ~ ?', "^#{char}")
    end
  }

  scope :with_title_firstchar, lambda { |char|
    if char == 'その他'
      where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      where('sortkey ~ ?', "^#{char}")
    end
  }

  validates :title, :started_on, :book_status, :kana_type, presence: true

  def author_text
    book_people.where(role_id: 1).map { |a| a.person.name }.join(', ')
  end

  def translator_text
    book_people.where(role_id: 2).map { |a| a.person.name }.join(', ')
  end

  def inputer_text
    book_workers.where(worker_role_id: 1).map { |bw| bw.worker.name }.join('、')
  end

  def proofreader_text
    book_workers.where(worker_role_id: 2).map { |bw| bw.worker.name }.join('、')
  end
end
