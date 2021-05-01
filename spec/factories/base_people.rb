# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :base_person do
    person_id { 1 }
  end
end
