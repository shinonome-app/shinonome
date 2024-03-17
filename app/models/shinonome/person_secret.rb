# frozen_string_literal: true

# == Schema Information
#
# Table name: person_secrets
#
#  id         :bigint           not null, primary key
#  memo       :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#
# Indexes
#
#  index_person_secrets_on_person_id  (person_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#
module Shinonome
  # Person非公開情報
  class PersonSecret < ApplicationRecord
    belongs_to :person
  end
end
