# frozen_string_literal: true

# == Schema Information
#
# Table name: work_people
#
#  id         :integer          not null, primary key
#  work_id    :integer          not null
#  person_id  :integer          not null
#  role_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_work_people_on_work_id    (work_id)
#  index_work_people_on_person_id  (person_id)
#  index_work_people_on_role_id    (role_id)
#

require 'rails_helper'

RSpec.describe WorkPerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
