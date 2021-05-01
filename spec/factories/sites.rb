# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  name       :text
#  url        :text
#  owner_name :text
#  email      :text
#  note       :text
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :site do
    name { "MyText" }
    url { "MyText" }
    owner_name { "MyText" }
    email { "MyText" }
    note { "MyText" }
    updated_by { 1 }
  end
end
