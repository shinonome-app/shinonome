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
# Indexes
#
#  index_person_sites_on_person_id  (person_id)
#  index_person_sites_on_site_id    (site_id)
#
# Foreign Keys
#
#  fk_rails_...  (person_id => people.id)
#  fk_rails_...  (site_id => sites.id)
#

require 'rails_helper'

RSpec.describe PersonSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
