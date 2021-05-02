# == Schema Information
#
# Table name: kana_types
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :kana_type do
    name { 'MyText' }
  end
end
