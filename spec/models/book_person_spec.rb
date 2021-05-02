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
require 'rails_helper'

RSpec.describe BookPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
