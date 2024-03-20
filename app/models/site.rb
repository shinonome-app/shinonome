# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  updated_by :bigint
#  url        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'csv'

# 関連サイト
class Site < ApplicationRecord
  belongs_to :updated_user,
             class_name: 'Shinonome::User',
             foreign_key: 'updated_by',
             inverse_of: false

  has_many :work_sites, dependent: :destroy
  has_many :works, through: :work_sites

  has_many :person_sites, dependent: :destroy
  has_many :people, through: :person_sites

  has_one :site_secret, class_name: 'Shinonome::SiteSecret', dependent: :destroy

  accepts_nested_attributes_for :site_secret, update_only: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]) }, allow_blank: true

  def self.csv_header
    "関連サイトid,関連サイト名,関連サイトurl,関連サイト運営者名,email,備考,最終更新日,更新者\r\n"
  end

  def to_csv
    array = [id, name, url, site_secret&.owner_name, site_secret&.email, site_secret&.memo, updated_at, updated_by]

    CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
  end
end
