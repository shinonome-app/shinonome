# == Schema Information
#
# Table name: charsets
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :charset do
    name { 'MyText' }
  end
end
