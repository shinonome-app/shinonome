# frozen_string_literal: true

require 'rails_helper'

describe Admin::Proofreads::OrdersController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '校正受付発注用画面の表示' do
    it 'ページが正しく表示される' do
      work = create(:work, :with_person, work_status_id: 5)
      worker = create(:worker, name: '青空太郎')
      proofread = create(:proofread, :non_ordered, work:, worker:)

      visit orders_new_admin_proofread_path(proofread)

      expect(page).to have_content('ファイルの送付')
      expect(page).to have_button('送付')
      # 必要な要素がページ上に存在するかを確認
    end
  end

  describe '校正受付発注の作成' do
    context '青空文庫にCCしない' do
      it '送付すると、成功のメッセージが表示されてメールが送信される' do
        allow(AdminMailer).to receive(:order_proofread).once.and_call_original
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit orders_new_admin_proofread_path(proofread)

        click_on '送付'

        expect(page).to have_content('送信しました')
        expect(page).to have_current_path(admin_proofreads_path, ignore_query: true)
        # 成功のフラッシュメッセージとリダイレクト先を確認
        expect(AdminMailer).to have_received(:order_proofread).twice
      end
    end

    context '青空文庫にCCする' do
      it '送付すると、成功のメッセージが表示されてメールが送信される' do
        allow(AdminMailer).to receive(:order_proofread).once.and_call_original
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit orders_new_admin_proofread_path(proofread)

        check '青空文庫にCCする'
        click_on '送付'

        expect(page).to have_content('送信しました')
        expect(page).to have_current_path(admin_proofreads_path, ignore_query: true)
        # 成功のフラッシュメッセージとリダイレクト先を確認
        expect(AdminMailer).to have_received(:order_proofread).twice
      end
    end
  end
end
