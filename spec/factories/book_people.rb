# == Schema Information
#
# Table name: book_people
#
#  id         :bigint           not null, primary key
#  book_id    :integer
#  person_id  :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :book_person do
    book_id { 1 }
    person_id { 1 }
    role_id { 1 }
  end
end
