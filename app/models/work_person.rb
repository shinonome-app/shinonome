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
#  index_work_people_on_person_id  (person_id)
#  index_work_people_on_role_id    (role_id)
#  index_work_people_on_work_id    (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (role_id => roles.id)
#  fk_rails_...  (work_id => works.id)
#

class WorkPerson < ApplicationRecord
  belongs_to :work
  belongs_to :person
  belongs_to :role
end
