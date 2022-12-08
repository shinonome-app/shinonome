# frozen_string_literal: true

require 'rails_helper'

describe TopController do
  describe '#index' do
    it 'トップページが表示される' do
      visit '/'
      expect(page).to have_content('作業着手連絡システム')
      expect(page).to have_content('入力受付システム')
      expect(page).to have_content('校正受付システム')
    end
  end
end
