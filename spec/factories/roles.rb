# == Schema Information
#
# Table name: roles
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :role do
    name { 'MyText' }
  end
end
