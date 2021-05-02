# frozen_string_literal: true

# == Schema Information
#
# Table name: sites
#
#  id         :bigint           not null, primary key
#  email      :text
#  name       :text
#  note       :text
#  owner_name :text
#  updated_by :integer
#  url        :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Site < ApplicationRecord
end
