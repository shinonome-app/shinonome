# frozen_string_literal: true

# == Schema Information
#
# Table name: compresstypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Compresstype, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
