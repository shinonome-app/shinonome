# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint
#
FactoryBot.define do
  factory :base_person do
    person_id { 1 }
  end
end
