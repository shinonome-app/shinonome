# frozen_string_literal: true

# == Schema Information
#
# Table name: book_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  book_id    :bigint           not null
#  person_id  :bigint           not null
#  role_id    :bigint           not null
#
# Indexes
#
#  index_book_people_on_book_id    (book_id)
#  index_book_people_on_person_id  (person_id)
#  index_book_people_on_role_id    (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (role_id => roles.id)
#
FactoryBot.define do
  factory :book_person do
    book_id { 1 }
    person_id { 1 }
    role_id { 1 }
  end
end
