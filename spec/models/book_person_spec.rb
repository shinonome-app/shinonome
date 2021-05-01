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
require 'rails_helper'

RSpec.describe BookPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
