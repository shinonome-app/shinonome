# frozen_string_literal: true

require 'rails_helper'

describe Admin::ReceiptsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    it '一覧に表示される' do
      create(:receipt, :non_ordered)

      visit '/admin/receipts'

      expect(page).to have_content('Web入力受付管理')
      expect(page).to have_content('Web受付作品一覧')
      expect(page).to have_content('1件の作品が見つかりました。')
      expect(page).to have_content('作品その一')
      expect(page).to have_content('旧字旧仮名')
      expect(page).to have_content('青空 文子')
      expect(page).to have_content('耕作員6')
      expect(page).to have_content('未')
    end
  end
end
