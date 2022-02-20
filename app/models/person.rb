# frozen_string_literal: true

# == Schema Information
#
# Table name: people
#
#  id              :integer          not null, primary key
#  last_name       :text             not null
#  last_name_kana  :text             not null
#  last_name_en    :text
#  first_name      :text
#  first_name_kana :text
#  first_name_en   :text
#  born_on         :date
#  died_on         :date
#  copyright_flag  :boolean          not null
#  email           :text
#  url             :text
#  description     :text
#  note_user_id    :integer
#  basename        :text
#  note            :text
#  updated_by      :text
#  sortkey         :text
#  sortkey2        :text
#  input_count     :integer
#  publish_count   :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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

  belongs_to :note_user, optional: true
  has_many :work_people, dependent: :destroy
  has_many :works, through: :work_people

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
