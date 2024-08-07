# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  note       :text
#  num        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint           not null
#

require 'csv'

# 書誌情報
class Bibclass < ApplicationRecord
  belongs_to :work

  validates :name, presence: true
  validates :num, presence: true

  def self.csv_header
    "bookid,分類名,分類番号,備考\r\n"
  end

  def to_s
    "#{name} #{num}"
  end

  def to_csv
    array = [work_id, name, num, note]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
