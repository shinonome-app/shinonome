# frozen_string_literal: true

# == Schema Information
#
# Table name: receipts
#
#  id                   :bigint           not null, primary key
#  collection           :text
#  collection_kana      :text
#  copyright_flag       :boolean          default(FALSE), not null
#  deleted_at           :datetime
#  email                :text             not null
#  first_appearance     :text
#  first_name           :text
#  first_name_en        :text
#  first_name_kana      :text
#  first_pubdate        :text             not null
#  first_pubdate2       :text
#  input_edition        :text             not null
#  last_name            :text             not null
#  last_name_en         :text
#  last_name_kana       :text             not null
#  memo                 :text
#  note                 :text
#  original_book_note   :text
#  original_book_title  :text             not null
#  original_book_title2 :text
#  original_title       :text
#  person_note          :text
#  publisher            :text             not null
#  publisher2           :text
#  register_status      :integer          default("non_ordered"), not null
#  started_on           :date             not null
#  subtitle             :text
#  subtitle_kana        :text
#  title                :text             not null
#  title_kana           :text             not null
#  url                  :text
#  worker_kana          :text             not null
#  worker_name          :text             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  kana_type_id         :text
#  person_id            :bigint
#  work_id              :bigint
#  work_status_id       :bigint           not null
#  worker_id            :bigint
#
# Indexes
#
#  index_receipts_on_work_status_id  (work_status_id)
#
# Foreign Keys
#
#  fk_rails_...  (work_status_id => work_statuses.id)
#

# 入力受付
class Receipt < ApplicationRecord
  belongs_to :kana_type, optional: true
  belongs_to :work_status
  belongs_to :worker, optional: true
  belongs_to :work, optional: true
  belongs_to :person, optional: true

  enum register_status: { non_ordered: 0, ordered: 1 }

  scope :active, -> { where(deleted_at: nil) }

  validates :title_kana, presence: true
  validates :title, presence: true
  validates :copyright_flag, inclusion: { in: [true, false] }
  validates :last_name_kana, presence: true
  validates :last_name, presence: true
  validates :worker_kana, presence: true
  validates :worker_name, presence: true
  validates :email, presence: true
  validates :original_book_title, presence: true
  validates :publisher, presence: true
  validates :first_pubdate, presence: true
  validates :input_edition, presence: true

  validates :register_status, presence: true
  validates :started_on, presence: true

  before_validation :set_statuses

  def name
    "#{last_name} #{first_name}"
  end

  def name_kana
    "#{last_name_kana} #{first_name_kana}"
  end

  def name_en
    "#{first_name_en}, #{last_name_en}" if last_name_en || first_name_en
  end

  def kana_type_name
    kana_type&.name
  end

  def work_status_name
    work_status&.name
  end

  def copyright_flag_name
    copyright_flag ? 'あり' : 'なし'
  end

  private

  def set_statuses
    self.work_status_id ||= 3 # 入力中
    self.register_status ||= 0
    self.started_on ||= Time.zone.now
  end
end
