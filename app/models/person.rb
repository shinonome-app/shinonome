# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :bigint           not null, primary key
#  basename        :text
#  born_on         :date
#  copyright_flag  :boolean          not null
#  description     :text
#  died_on         :date
#  email           :text
#  first_name      :text
#  first_name_en   :text
#  first_name_kana :text
#  input_count     :integer
#  last_name       :text             not null
#  last_name_en    :text
#  last_name_kana  :text             not null
#  note            :text
#  publish_count   :integer
#  sortkey         :text
#  sortkey2        :text
#  updated_by      :text
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  note_user_id    :bigint
#
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

  belongs_to :note_user, optional: true
  has_many :book_people, dependent: :destroy
  has_many :books, through: :book_people

  def copyright_text
    copyright_flag ? '有' : '無'
  end

  def name
    "#{last_name} #{first_name}"
  end

  def name_en
    "#{first_name_en}, #{last_name_en}" if last_name_en || first_name_en
  end

  validates :last_name, :last_name_kana, presence: true
  validates :copyright_flag, inclusion: { in: [true, false] }
  validates :input_count, :publish_count, numericality: { only_integer: true }, allow_nil: true
end
