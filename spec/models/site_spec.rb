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

require 'rails_helper'

RSpec.describe Site do
  pending "add some examples to (or delete) #{__FILE__}"
end
