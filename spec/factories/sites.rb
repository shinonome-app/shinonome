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

FactoryBot.define do
  factory :site do
    transient do
      n { rand(1..1000) }
    end

    name { "関連サイト#{n}" }
    url { "https://shinonome.example.com/sites/#{n}" }
    updated_by { 1 }
  end
end
