# frozen_string_literal: true

# == Schema Information
#
# Table name: booktypes
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Booktype do
  describe 'seed' do
    it '正しいseedを持つ' do
      expect(Booktype.find(1).name).to eq '底本'
      expect(Booktype.find(2).name).to eq '底本の親本'
    end
  end
end
