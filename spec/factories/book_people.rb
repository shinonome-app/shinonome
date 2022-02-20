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

FactoryBot.define do
  factory :work_person do
    work_id { 1 }
    person_id { 1 }
    role_id { 1 }
  end
end
