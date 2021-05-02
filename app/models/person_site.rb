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
class PersonSite < ApplicationRecord
  belongs_to :person
  belongs_to :site
end
