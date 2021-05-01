# == Schema Information
#
# Table name: compresstypes
#
#  id         :bigint           not null, primary key
#  name       :text
#  extension  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :compresstype do
    name { "MyText" }
    extension { "MyText" }
  end
end
