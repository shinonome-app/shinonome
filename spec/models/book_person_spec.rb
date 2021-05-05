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
require 'rails_helper'

RSpec.describe BookPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
