# frozen_string_literal: true

# == Schema Information
#
# Table name: work_sites
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :bigint           not null
#  work_id    :bigint           not null
#
# Indexes
#
#  index_work_sites_on_site_id              (site_id)
#  index_work_sites_on_work_id              (work_id)
#  index_work_sites_on_work_id_and_site_id  (work_id,site_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#  fk_rails_...  (work_id => works.id)
#

FactoryBot.define do
  factory :work_site do
    work
    site
  end
end
