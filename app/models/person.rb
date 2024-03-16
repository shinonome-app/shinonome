# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :text
#  copyright_flag  :boolean          default(FALSE), not null
#  description     :text
#  died_on         :text
#  email           :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text             not null
#  last_name_en    :text
#  last_name_kana  :text             not null
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :bigint
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'csv'

# 人物(著者等)
class Person < ApplicationRecord
  PERSON_ID_TABLE = [
    %w[あ い う え お],
    %w[か き く け こ],
    %w[さ し す せ そ],
    %w[た ち つ て と],
    %w[な に ぬ ね の],
    %w[は ひ ふ へ ほ],
    %w[ま み む め も],
    ['や', nil, 'ゆ', nil, 'よ'],
    %w[ら り る れ ろ],
    ['わ', nil, 'を', nil, 'ん']
  ].freeze

  belongs_to :updated_user,
             class_name: 'Shinonome::User',
             optional: true,
             foreign_key: 'updated_by',
             inverse_of: false

  has_many :work_people, dependent: :destroy
  has_many :works, through: :work_people
  has_one :base_person, dependent: :destroy
  has_one :original_person, through: :base_person
  has_many :person_sites, dependent: :destroy
  has_many :sites, through: :person_sites

  has_one :person_secret,
          class_name: 'Shinonome::PersonSecret',
          required: true,
          dependent: :destroy

  accepts_nested_attributes_for :person_secret, update_only: true

  validates :last_name, :last_name_kana, presence: true
  validates :copyright_flag, inclusion: { in: [true, false] }
  validates :input_count, :publish_count, numericality: { only_integer: true }, allow_nil: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  scope :with_name_firstchar, lambda { |char|
    if char.blank? || char == 'その他'
      where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      where('sortkey ~ ?', "^#{char}")
    end
  }

  def self.csv_header
    "人物id,姓,姓読み,姓英字,名,名読み,名英字,生年月日,没年月日,著作権フラグ,email,url,人物について,人物基本名,備考,最終更新日,更新者,姓ソート用読み,名ソート用読み\r\n"
  end

  def to_csv
    array = [id, last_name, last_name_kana, last_name_en, first_name, first_name_kana, first_name_en, born_on, died_on, copyright_char, email, url, description, basename, person_secret&.memo, updated_at, updated_by, sortkey, sortkey2]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end

  def other_people
    other_person_ids = BasePerson.where(person_id: id).pluck(:original_person_id) +
                       BasePerson.where(original_person_id: id).pluck(:person_id)
    Person.where(id: other_person_ids)
  end

  def copyright?
    copyright_flag
  end

  def copyright_text
    copyright_flag ? '有' : '無'
  end

  def copyright_char
    copyright_flag ? 't' : 'f'
  end

  def copyright_flag_name
    copyright_flag ? 'あり' : 'なし'
  end

  def name
    "#{last_name} #{first_name}"
  end

  def name_kana
    "#{last_name_kana} #{first_name_kana}"
  end

  def name_en
    "#{first_name_en}, #{last_name_en}" if last_name_en || first_name_en
  end

  def published_works
    Work.joins(:work_people).published.where(work_people: { person_id: id })
  end

  def unpublished_works
    Work.joins(:work_people).unpublished.where(work_people: { person_id: id })
  end
end
