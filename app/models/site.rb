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
#  updated_by :integer
#  url        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Site < ApplicationRecord
  has_many :book_sites, dependent: :destroy
  has_many :books, through: :book_sites
end
