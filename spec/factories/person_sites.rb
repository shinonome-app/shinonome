# frozen_string_literal: true

# == Schema Information
#
# Table name: person_sites
#
#  id         :integer          not null, primary key
#  person_id  :integer          not null
#  site_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_person_sites_on_person_id  (person_id)
#  index_person_sites_on_site_id    (site_id)
#

FactoryBot.define do
  factory :person_site do
    person_id { 1 }
    site_id { '' }
  end
end
