# == Schema Information
#
# Table name: base_people
#
#  id         :bigint           not null, primary key
#  person_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BasePerson < ApplicationRecord
end
