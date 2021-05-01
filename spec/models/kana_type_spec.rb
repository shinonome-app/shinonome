# == Schema Information
#
# Table name: kana_types
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe KanaType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
