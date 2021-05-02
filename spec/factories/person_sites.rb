# == Schema Information
#
# Table name: person_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  person_id  :bigint
#  site_id    :bigint
#
FactoryBot.define do
  factory :person_site do
    person_id { 1 }
    site_id { "" }
  end
end
