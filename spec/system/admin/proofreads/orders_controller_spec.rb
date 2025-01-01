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
        ActionMailer::Base.deliveries.clear

        work = create(:work, :with_person, :teihon, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit orders_new_admin_proofread_path(proofread)

        perform_enqueued_jobs do
          click_on '送付'
        end

        expect(page).to have_content('送信しました')
        expect(page).to have_current_path(admin_proofreads_path, ignore_query: true)
        # 成功のフラッシュメッセージとリダイレクト先を確認

        expect(ActionMailer::Base.deliveries.size).to eq(1)

        mail = ActionMailer::Base.deliveries.last
        expect(mail.to).to include('worker@example.com')
        expect(mail.from).to include('from@example.com')
        expect(mail.subject).to eq("「#{work.title} #{work.subtitle}」校正のお願い")
        expect(mail.body.encoded).to include('青空文庫は、以下の内容で校正申し入れのあった作品を、校正していただくための準備を終え')
        expect(mail.body.encoded).to include("工作員ID：#{worker.id}")
        expect(mail.body.encoded).to include("校正者名：#{worker.name}")
        expect(mail.body.encoded).to include("作品名　　　　　：#{work.title}")
      end
    end

    context '青空文庫にCCする' do
      it '送付すると、成功のメッセージが表示されてメールが送信される' do
        work = create(:work, :with_person, :teihon, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit orders_new_admin_proofread_path(proofread)

        check '青空文庫にCCする'
        perform_enqueued_jobs do
          click_on '送付'
        end

        expect(page).to have_content('送信しました')
        expect(page).to have_current_path(admin_proofreads_path, ignore_query: true)
        # 成功のフラッシュメッセージとリダイレクト先を確認

        expect(ActionMailer::Base.deliveries.size).to eq(1)

        mail = ActionMailer::Base.deliveries.last

        expect(mail.to).to include('worker@example.com')
        expect(mail.from).to include('from@example.com')
        expect(mail.subject).to eq("「#{work.title} #{work.subtitle}」校正のお願い")
        expect(mail.body.encoded).to include('青空文庫は、以下の内容で校正申し入れのあった作品を、校正していただくための準備を終え')
        expect(mail.body.encoded).to include("工作員ID：#{worker.id}")
        expect(mail.body.encoded).to include("校正者名：#{worker.name}")
        expect(mail.body.encoded).to include("作品名　　　　　：#{work.title}")
      end
    end
  end
end
