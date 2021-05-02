# frozen_string_literal: true

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
class BookPerson < ApplicationRecord
  belongs_to :book
  belongs_to :person
  belongs_to :role
end
