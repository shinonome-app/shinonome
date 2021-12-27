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

require 'rails_helper'

RSpec.describe Site, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
