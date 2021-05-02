# == Schema Information
#
# Table name: news
#
#  id           :bigint           not null, primary key
#  body         :text
#  flag         :boolean
#  published_on :date
#  title        :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :news do
    published_on { '2021-04-29' }
    title { 'MyText' }
    body { 'MyText' }
    flag { false }
  end
end
