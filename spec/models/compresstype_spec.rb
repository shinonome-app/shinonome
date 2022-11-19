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
  describe 'compressed?' do
    it 'none' do
      expect(Compresstype.find(1).compressed?).to eq false
    end

    it 'zip' do
      expect(Compresstype.find(2).compressed?).to eq true
    end

    it 'gzip' do
      expect(Compresstype.find(3).compressed?).to eq true
    end
  end
end
