# frozen_string_literal: true
# == Schema Information
#
# Table name: compresstypes
#
#  id         :integer          not null, primary key
#  name       :text
#  extension  :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Compresstype, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
