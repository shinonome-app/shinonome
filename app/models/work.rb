# frozen_string_literal: true

# == Schema Information
#
# Table name: works
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
#  published_on          :date
#  sortkey               :text
#  started_on            :date             not null
#  subtitle              :text
#  subtitle_kana         :text
#  title                 :text             not null
#  title_kana            :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  description_person_id :bigint
#  kana_type_id          :bigint           not null
#  user_id               :bigint           not null
#  work_status_id        :bigint           not null
#
# Indexes
#
#  index_works_on_kana_type_id    (kana_type_id)
#  index_works_on_user_id         (user_id)
#  index_works_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (kana_type_id => kana_types.id)
#  fk_rails_...  (work_status_id => work_statuses.id)
#

# 作品
class Work < ApplicationRecord
  has_many :work_sites, dependent: :destroy
  has_many :sites, through: :work_sites
  has_many :work_people, dependent: :destroy
  has_many :people, through: :work_people
  has_many :work_workers, dependent: :destroy
  has_many :workers, through: :work_workers
  has_many :workfiles, dependent: :destroy

  has_many :bibclasses, dependent: :destroy
  has_many :original_books, dependent: :destroy

  belongs_to :user, class_name: 'Shinonome::User'
  belongs_to :kana_type
  belongs_to :work_status

  scope :with_year_and_status, ->(year, status) { where('extract(year from created_at) = ? AND work_status_id = ?', year, status) }

  scope :with_creator_firstchar, lambda { |char|
    if char.blank? || char == 'その他'
      joins(:people).where('people.sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      joins(:people).where('people.sortkey ~ ?', "^#{char}")
    end
  }

  scope :with_title_firstchar, lambda { |char|
    if char.blank? || char == 'その他'
      where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      where('sortkey ~ ?', "^#{char}")
    end
  }

  scope :published, ->(date = Time.zone.today) { where('work_status_id = 1 AND published_on <= ?', date) }
  scope :unpublished, ->(date = Time.zone.today) { where('work_status_id in (3, 4, 5, 6, 7, 8, 9, 10, 11) or published_on is null or published_on > ?', date) }

  validates :title, :started_on, presence: true

  def self.latest_published(year: nil, until_date: Time.zone.today)
    year ||= until_date.year

    Work.where('work_status_id = 1 AND published_on IS NOT NULL AND extract(year from published_on) = ? AND published_on <= ?', year, until_date)
  end

  def copyright?
    people.any? { |person| person.copyright? }
  end

  def noncopyright?
    people.all? { |person| !person.copyright? }
  end

  def first_author
    work_people.where(role_id: 1).first.person
  end

  def card_person_id
    format('%06d', first_author.id)
  end

  def first_teihon
    original_books.where(worktype: 1).first
  end

  def author_text
    work_people.where(role_id: 1).map { |a| a.person.name }.join(', ')
  end

  def translator_text
    work_people.where(role_id: 2).map { |a| a.person.name }.join(', ')
  end

  def inputer_text
    work_workers.where(worker_role_id: 1).map { |bw| bw.worker.name }.join('、')
  end

  def proofreader_text
    work_workers.where(worker_role_id: 2).map { |bw| bw.worker.name }.join('、')
  end
end
