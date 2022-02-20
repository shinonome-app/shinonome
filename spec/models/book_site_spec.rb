# frozen_string_literal: true

# == Schema Information
#
# Table name: work_sites
#
#  id         :integer          not null, primary key
#  work_id    :integer          not null
#  site_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_work_sites_on_work_id  (work_id)
#  index_work_sites_on_site_id  (site_id)
#

require 'rails_helper'

RSpec.describe WorkSite, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
