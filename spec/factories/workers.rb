# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  name       :text
#  name_kana  :text
#  email      :text
#  url        :text
#  note       :text
#  user_id    :integer
#  sortkey    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :worker do
    name { "MyText" }
    name_kana { "MyText" }
    email { "MyText" }
    url { "MyText" }
    note { "MyText" }
    user_id { 1 }
    sortkey { "MyText" }
  end
end
