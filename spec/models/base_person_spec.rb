# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint
#
require 'rails_helper'

RSpec.describe BasePerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
