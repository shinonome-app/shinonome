# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  email      :text
#  name       :text             not null
#  note       :text
#  owner_name :text
#  updated_by :bigint
#  url        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'csv'

# 関連サイト
class Site < ApplicationRecord
  has_many :work_sites, dependent: :destroy
  has_many :works, through: :work_sites

  validates :name, :url, presence: true

  def self.csv_header
    "関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考,最終更新日,更新者\r\n"
  end

  def to_csv
    array = [id, name, url, owner_name, email, note, updated_at, updated_by]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
