# frozen_string_literal: true

# == Schema Information
#
# Table name: person_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint           not null
#  site_id    :bigint           not null
#
FactoryBot.define do
  factory :person_site do
    person_id { 1 }
    site_id { '' }
  end
end
