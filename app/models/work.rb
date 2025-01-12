# frozen_string_literal: true

# == Schema Information
#
# Table name: works
#
#  id                    :bigint           not null, primary key
#  author_display_name   :text
#  collection            :text
#  collection_kana       :text
#  copyright_flag        :boolean          default(FALSE), not null
#  description           :text
#  first_appearance      :text
#  note                  :text
#  original_title        :text
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

# published_onは不要かも？

require 'csv'

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

  has_one :work_secret,
          class_name: 'Shinonome::WorkSecret',
          required: true,
          dependent: :destroy

  accepts_nested_attributes_for :work_secret, update_only: true

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

  scope :published, ->(date = Time.zone.today) { where('work_status_id = 1 AND started_on <= ?', date) }
  scope :unpublished, ->(date = Time.zone.today) { where('work_status_id in (3, 4, 5, 6, 7, 8, 9, 10, 11) OR (work_status_id = 1 AND started_on > ?)', date) }
  scope :not_proofread, -> { where('work_status_id in (5, 6)') }

  before_validation :set_sortkey

  validates :title_kana, presence: true
  validates :title, presence: true
  validates :copyright_flag, inclusion: { in: [true, false] }
  validates :kana_type_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :kana_type_id, inclusion: { in: [1, 2, 3, 4, 99] }, if: -> { kana_type_id.present? }
  validates :started_on, presence: true
  validates :work_status_id, presence: true # rubocop:disable Rails/RedundantPresenceValidationOnBelongsTo
  validates :work_status_id, inclusion: { in: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12] }, if: -> { work_status_id.present? }

  def self.copyrighted_count
    published.joins(:people)
             .where(people: { copyright_flag: true })
             .distinct.count
  end

  def self.non_copyrighted_count
    published.joins(:people)
      .group('works.id')
      .having('bool_and(people.copyright_flag = false)')
      .distinct.pluck('works.id').size
  end

  def self.csv_header
    "bookid,作品名,作品名読み,副題,副題読み,作品集名,作品集名読み,原題,仮名遣い種別,初出,作品について,状態,状態の開始日,著作権フラグ,備考,底本管理情報,最終更新日,更新者,ソート用読み\r\n"
  end

  def self.csv_header_with_site
    "bookid,作品名,作品名読み,副題,副題読み,作品集名,作品集名読み,原題,仮名遣い種別,初出,状態,状態の開始日,著作権フラグ,備考,底本管理情報,最終更新日,更新者,人物1 ID,人物1 姓名,人物1 役割,人物2 ID,人物2 姓名,人物2 役割,人物3 ID,人物3 姓名,人物2 役割,人物4 ID,人物4 姓名,人物4 役割,関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考\r\n"
  end

  def to_csv
    array = [id, title, title_kana, subtitle, subtitle_kana, collection, collection_kana, original_title, kana_type_name, first_appearance, description, work_status.name, started_on, copyright_char, note, work_secret&.orig_text, updated_at, user.username, sortkey]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end

  def to_csv_with_site
    people_array = work_people.map { |work_person| [work_person.person_id, work_person.person.name, work_person.role.name] }

    rest_people_count = 4 - people_array.count
    rest_people_count = 0 if rest_people_count < 0
    people_array.flatten!
    people_array += ['', '', ''] * rest_people_count

    work_site = work_sites.first
    sites_array = if work_site
                    [sites[0].id, sites[0].name, sites[0].url, sites[0].site_secret&.owner_name, sites[0].site_secret&.email, sites[0].site_secret&.memo]
                  else
                    ['', '', '', '', '', '']
                  end

    array = [id, title, title_kana, subtitle, subtitle_kana, collection, collection_kana, original_title, kana_type_name, first_appearance, work_status.name, started_on, copyright_char, note, work_secret&.orig_text, updated_at, user.username] + people_array + sites_array

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end

  def self.latest_published(year: nil, until_date: Time.zone.today)
    year ||= until_date.year

    Work.where('work_status_id = 1 AND started_on IS NOT NULL AND extract(year from started_on) = ? AND started_on <= ?', year, until_date)
  end

  def copyright?
    people.any? { |person| person.copyright? }
  end

  def copyright_char
    copyright_flag ? 't' : 'f'
  end

  def noncopyright?
    people.all? { |person| !person.copyright? }
  end

  def copyright_flag_name
    copyright_flag ? 'あり' : 'なし'
  end

  def proofread_waiting_inspected?
    work_status_id == 5
  end

  def proofread_reserved_inspected!
    self.work_status_id = 7
    save!
  end

  def proofread_reserved!
    self.work_status_id = 8
    save!
  end

  def first_author
    work_people.where(role_id: 1).first&.person
  end

  def kana_type_name
    kana_type&.name
  end

  def card_person_id
    format('%06d', first_author.id)
  end

  def first_teihon
    original_books.where(booktype: 1).first
  end

  def first_oyahon
    original_books.where(booktype: 2).first
  end

  def author_text
    work_people.where(role_id: 1).map { |a| a.person.name }.join(', ')
  end

  def base_author_text
    work_people.where(role_id: 1).map { |a| a.person.original_person&.name }.compact.join(', ')
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

  def workfile
    workfiles.order(id: :desc).last
  end

  def updated_at_text
    updated_at.strftime('%Y年%m月%d日').gsub('年0', '年').gsub('月0', '月')
  end

  def card_url
    "https://www.aozora.gr.jp/cards/#{card_person_id}/card#{id}.html"
  end

  def xhtml_link
    workfiles.find { |workfile| workfile.html? }
  end

  def full_title
    if subtitle.present?
      "#{title} #{subtitle}"
    else
      title
    end
  end

  private

  def set_sortkey
    self.sortkey = Kana.convert_sortkey(title_kana) if sortkey.blank?
  end
end
