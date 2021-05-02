# == Schema Information
#
# Table name: file_encodings
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :file_encoding do
    name { 'MyText' }
  end
end
