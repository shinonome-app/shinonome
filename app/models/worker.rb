# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  sortkey    :text
#  updated_by :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# 工作員
class Worker < ApplicationRecord
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

  TEXT_SELECTOR = [
    ['を含む', 1],
    ['で始まる', 2],
    ['で終わる', 3],
    ['と等しい', 4]
  ].freeze

  has_many :work_workers, dependent: :destroy
  has_many :works, through: :work_workers

  has_one :worker_secret,
          class_name: 'Shinonome::WorkerSecret',
          required: true,
          dependent: :destroy

  accepts_nested_attributes_for :work_workers
  accepts_nested_attributes_for :worker_secret, update_only: true

  scope :with_name_kana_search, lambda { |name_kana, selector|
    case selector.to_i
    when 1 # を含む
      where('name_kana like ?', "%#{name_kana}%")
    when 2 # で始まる
      where('name_kana like ?', "#{name_kana}%")
    when 3 # で終わる
      where('name_kana like ?', "%#{name_kana}")
    when 4 # と等しい
      where(name_kana: name_kana)
    end
  }

  scope :with_name_search, lambda { |name, selector|
    case selector.to_i
    when 1 # を含む
      where('name like ?', "%#{name}%")
    when 2 # で始まる
      where('name like ?', "#{name}%")
    when 3 # で終わる
      where('name like ?', "%#{name}")
    when 4 # と等しい
      where(name: name)
    end
  }

  scope :with_name_firstchar, lambda { |char|
    if char.blank? || char == 'その他'
      where('sortkey !~ ?', '^[あいうえおか-もやゆよら-ろわをんアイウエオカ-モヤユヨラ-ロワヲンヴ]')
    else
      where('sortkey ~ ?', "^#{char}")
    end
  }

  validates :name, :name_kana, presence: true

  def self.csv_header
    "工作員id,姓名,姓名読み,email,url,備考,最終更新日,更新者,姓名ソート用読み\r\n"
  end

  def to_csv
    array = [id, name, name_kana, worker_secret.email, worker_secret.url, worker_secret.note, updated_at, updated_by, sortkey]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
