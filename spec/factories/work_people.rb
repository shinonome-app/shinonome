# frozen_string_literal: true

# == Schema Information
#
# Table name: work_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  role_id    :bigint           not null
#  work_id    :bigint           not null
#
# Indexes
#
#  index_work_people_on_person_id                          (person_id)
#  index_work_people_on_role_id                            (role_id)
#  index_work_people_on_work_id                            (work_id)
#  index_work_people_on_work_id_and_person_id              (work_id,person_id)
#  index_work_people_on_work_id_and_person_id_and_role_id  (work_id,person_id,role_id) UNIQUE
#  index_work_people_on_work_id_and_role_id                (work_id,role_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (work_id => works.id)
#

FactoryBot.define do
  factory :work_person do
    work
    person
    role_id { 1 }
  end
end
