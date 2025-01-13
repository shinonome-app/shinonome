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
FactoryBot.define do
  factory :editable_content do
    area_name { 'default_area' }
    key { 'default_key' }
    value { 'Default value for testing' }
    created_at { Time.current }
  end
end
