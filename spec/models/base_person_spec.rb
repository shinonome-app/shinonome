# frozen_string_literal: true
# == Schema Information
#
# Table name: base_people
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_base_people_on_person_id  (person_id)
#

require 'rails_helper'

RSpec.describe BasePerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
