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

FactoryBot.define do
  factory :base_person do
    person_id { 1 }
  end
end
