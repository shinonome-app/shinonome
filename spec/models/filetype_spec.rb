# frozen_string_literal: true

# == Schema Information
#
# Table name: filetypes
#
#  id         :bigint           not null, primary key
#  extension  :text
#  name       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Filetype do
  describe 'html?' do
    it '正しい結果を返す' do
      expect(Filetype.find(1).html?).to eq false
      expect(Filetype.find(2).html?).to eq false
      expect(Filetype.find(3).html?).to eq true
      expect(Filetype.find(4).html?).to eq false
      expect(Filetype.find(8).html?).to eq false
      expect(Filetype.find(9).html?).to eq true
    end
  end

  describe 'text?' do
    it '正しい結果を返す' do
      expect(Filetype.find(0).text?).to eq true
      expect(Filetype.find(1).text?).to eq true
      expect(Filetype.find(2).text?).to eq true
      expect(Filetype.find(3).text?).to eq false
      expect(Filetype.find(4).text?).to eq false
      expect(Filetype.find(9).text?).to eq false
    end
  end

  describe 'rtxt?' do
    it '正しい結果を返す' do
      expect(Filetype.find(0).rtxt?).to eq false
      expect(Filetype.find(1).rtxt?).to eq true
      expect(Filetype.find(2).rtxt?).to eq false
      expect(Filetype.find(3).rtxt?).to eq false
      expect(Filetype.find(4).rtxt?).to eq false
      expect(Filetype.find(9).rtxt?).to eq false
    end
  end
end
