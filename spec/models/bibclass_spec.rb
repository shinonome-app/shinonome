# frozen_string_literal: true

# == Schema Information
#
# Table name: bibclasses
#
#  id         :bigint           not null, primary key
#  name       :text             not null
#  note       :text
#  num        :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  work_id    :bigint           not null
#

require 'rails_helper'

RSpec.describe Bibclass do
  describe '.csv_header' do
    it '値は決め打ち' do
      expect(Bibclass.csv_header).to eq "bookid,分類名,分類番号,備考\r\n"
    end
  end
end
