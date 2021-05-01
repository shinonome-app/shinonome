# == Schema Information
#
# Table name: charsets
#
#  id         :bigint           not null, primary key
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Charset, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
