# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Proofreads::OrdersController do
  let(:admin_user) { create(:user) }
  let(:worker) { create(:worker) }
  let(:worker_secret) { create(:worker_secret, worker:) }
  let(:work) { create(:work, :teihon, :with_person) }
  let(:proofread) { create(:proofread, worker:, work:) }

  before do
    sign_in admin_user # Devise を使用している場合の認証
  end

  describe 'GET #new' do
    it 'リクエストが成功し、新規発注画面が表示される' do
      get orders_new_admin_proofread_path(proofread.id)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('ファイルの送付')
      expect(response.body).to include('校正者からの連絡事項')
      expect(response.body).to include('校正者へのメールにそえるメッセージ')
    end
  end

  describe 'POST /admin/proofreads/orders' do
    let(:valid_params) do
      {
        proofread: {
          mail_memo: 'テストメールメモ',
          work_id: work.id
        }
      }
    end

    let(:invalid_params) do
      {
        proofread: {
          mail_memo: nil, # メモが必須だが欠けている
          work_id: nil
        }
      }
    end

    context '有効なパラメータの場合' do
      it '発注が成功し、メールが送信され、リダイレクトする' do
        perform_enqueued_jobs do
          post orders_admin_proofread_path(proofread.id), params: valid_params
        end

        expect(response).to redirect_to(admin_proofreads_path)
        follow_redirect!
        expect(response.body).to include('送信しました.')

        expect(ActionMailer::Base.deliveries.size).to eq(1)
      end
    end
  end
end
