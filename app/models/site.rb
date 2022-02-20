# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :text             not null
#  url        :text             not null
#  owner_name :text
#  email      :text
#  note       :text
#  updated_by :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Site < ApplicationRecord
  has_many :work_sites, dependent: :destroy
  has_many :works, through: :work_sites

  accepts_nested_attributes_for :work_sites
end
