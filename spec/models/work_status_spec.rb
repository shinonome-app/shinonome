# frozen_string_literal: true

# == Schema Information
#
# Table name: work_statuses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  sort_order :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe WorkStatus do
  pending "add some examples to (or delete) #{__FILE__}"
end
