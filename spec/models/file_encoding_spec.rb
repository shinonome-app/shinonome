# frozen_string_literal: true

# == Schema Information
#
# Table name: file_encodings
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe FileEncoding, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
