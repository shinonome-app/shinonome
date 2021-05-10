# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  email      :text             not null
#  name       :text             not null
#  name_kana  :text             not null
#  note       :text
#  sortkey    :text
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
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

  belongs_to :user, optional: true
  has_many :book_workers, dependent: :destroy
  has_many :books, through: :book_workers

  accepts_nested_attributes_for :book_workers

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

  validates :name, :name_kana, :email, presence: true
end
