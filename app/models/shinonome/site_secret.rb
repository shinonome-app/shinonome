# frozen_string_literal: true

# == Schema Information
#
# Table name: site_secrets
#
#  id         :bigint           not null, primary key
#  email      :text
#  note       :text
#  owner_name :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  site_id    :bigint
#
# Indexes
#
#  index_site_secrets_on_site_id  (site_id)
#
module Shinonome
  # サイト非公開情報
  class SiteSecret < ApplicationRecord
    belongs_to :worker

    validates :email, presence: true
  end
end
