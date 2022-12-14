# frozen_string_literal: true

# == Schema Information
#
# Table name: workers
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  name_kana  :text             not null
#  sortkey    :text
#  updated_by :bigint
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Worker do
  pending "add some examples to (or delete) #{__FILE__}"
end
