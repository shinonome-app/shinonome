# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint
#
class BasePerson < ApplicationRecord
  belongs_to :person
end
