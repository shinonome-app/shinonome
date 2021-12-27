# frozen_string_literal: true
# == Schema Information
#
# Table name: book_people
#
#  id         :integer          not null, primary key
#  book_id    :integer          not null
#  person_id  :integer          not null
#  role_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_book_people_on_book_id    (book_id)
#  index_book_people_on_person_id  (person_id)
#  index_book_people_on_role_id    (role_id)
#

FactoryBot.define do
  factory :book_person do
    book_id { 1 }
    person_id { 1 }
    role_id { 1 }
  end
end
