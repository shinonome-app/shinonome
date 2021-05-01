# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe BasePerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
