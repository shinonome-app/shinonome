# frozen_string_literal: true

# == Schema Information
#
# Table name: base_people
#
#  id                 :bigint           not null, primary key
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  original_person_id :bigint           not null
#  person_id          :bigint           not null
#
# Indexes
#
#  index_base_people_on_original_person_id  (original_person_id)
#  index_base_people_on_person_id           (person_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (original_person_id => people.id)
#  fk_rails_...  (person_id => people.id)
#

require 'rails_helper'

RSpec.describe BasePerson, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
