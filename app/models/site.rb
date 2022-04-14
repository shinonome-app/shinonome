# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  email      :text
#  name       :text             not null
#  note       :text
#  owner_name :text
#  updated_by :bigint
#  url        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Site < ApplicationRecord
  has_many :work_sites, dependent: :destroy
  has_many :works, through: :work_sites

  accepts_nested_attributes_for :work_sites
end
