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

require 'rails_helper'

RSpec.describe PersonSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
