# frozen_string_literal: true

# == Schema Information
#
# Table name: site_secrets
#
#  id         :bigint           not null, primary key
#  email      :text             default(""), not null
#  memo       :text             default(""), not null
#  owner_name :text             default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :bigint           not null
#
# Indexes
#
#  index_site_secrets_on_site_id  (site_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (site_id => sites.id)
#
module Shinonome
  # サイト非公開情報
  class SiteSecret < ApplicationRecord
    belongs_to :site
  end
end
