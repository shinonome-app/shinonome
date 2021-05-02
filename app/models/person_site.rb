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
class PersonSite < ApplicationRecord
  belongs_to :person
  belongs_to :site
end
