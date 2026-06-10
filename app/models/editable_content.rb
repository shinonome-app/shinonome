# frozen_string_literal: true

# == Schema Information
#
# Table name: editable_contents
#
#  id           :bigint           not null, primary key
#  area_name    :string
#  key          :string
#  published_at :datetime
#  status       :string           default("draft"), not null
#  value        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_editable_contents_on_area_name_and_key             (area_name,key)
#  index_editable_contents_on_area_name_and_key_and_status  (area_name,key,status)
#
class EditableContent < ApplicationRecord
  enum :status, { draft: 'draft', published: 'published' }

  validates :area_name, presence: true
  validates :key, presence: true
  validates :status, presence: true

  before_validation :set_published_at, if: :published?

  # 最新の編集内容を取得
  def self.latest_for(area_name, key)
    where(area_name:, key:).order(created_at: :desc).first
  end

  def self.latest_published_for(area_name, key)
    published.where(area_name:, key:).order(published_at: :desc, created_at: :desc).first
  end

  def self.latest_draft_for(area_name, key)
    draft.where(area_name:, key:).order(created_at: :desc).first
  end

  private

  def set_published_at
    self.published_at ||= Time.zone.now
  end
end
