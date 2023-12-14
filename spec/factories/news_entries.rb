# frozen_string_literal: true

# == Schema Information
#
# Table name: news_entries
#
#  id           :bigint           not null, primary key
#  body         :text             not null
#  flag         :boolean          default(FALSE), not null
#  published_on :date
#  title        :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :news_entry do
    published_on { '2021-04-29' }
    title { 'MyText' }
    body { 'MyText' }
    flag { false }
  end
end
