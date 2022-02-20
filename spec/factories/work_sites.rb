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

FactoryBot.define do
  factory :work_site do
    work_id { 1 }
    site_id { 1 }
  end
end
