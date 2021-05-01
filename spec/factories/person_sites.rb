# == Schema Information
#
# Table name: person_sites
#
#  id         :bigint           not null, primary key
#  person_id  :integer
#  site_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :person_site do
    person_id { 1 }
    site_id { "" }
  end
end
