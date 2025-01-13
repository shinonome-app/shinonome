# frozen_string_literal: true

# == Schema Information
#
# Table name: editable_contents
#
#  id         :bigint           not null, primary key
#  area_name  :string
#  key        :string
#  value      :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_editable_contents_on_area_name_and_key  (area_name,key)
#
class EditableContent < ApplicationRecord
  validates :area_name, presence: true
  validates :key, presence: true

  # 最新の編集内容を取得
  def self.latest_for(area_name, key)
    where(area_name:, key:).order(created_at: :desc).first
  end
end
