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
  describe 'sortkey' do
    it 'sortkeyがない場合、自動でname_kanaが入る（濁点、拗音等は変換される）' do
      worker = Worker.create(name: '青空今日子', name_kana: 'あおぞらきょうこ')
      expect(worker.sortkey).to eq 'あおそらきようこ'
    end

    it 'name_kanaがカタカナの場合はひらがなになる' do
      worker = Worker.create(name: '青空今日子', name_kana: 'アオゾラキョウコ')
      expect(worker.sortkey).to eq 'あおそらきようこ'
    end
  end
end
