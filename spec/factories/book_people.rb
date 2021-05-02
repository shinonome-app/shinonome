# == Schema Information
#
# Table name: book_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint
#  person_id  :bigint
#  role_id    :bigint
#
FactoryBot.define do
  factory :book_person do
    book_id { 1 }
    person_id { 1 }
    role_id { 1 }
  end
end
