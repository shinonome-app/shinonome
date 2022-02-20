# frozen_string_literal: true
# == Schema Information
#
# Table name: workers
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :worker do
    name { 'MyText' }
    name_kana { 'MyText' }
    sortkey { 'MyText' }
  end
end
