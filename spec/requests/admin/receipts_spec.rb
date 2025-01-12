# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ReceiptsController do
  let(:admin_user) { create(:user) }
  let(:receipt) { create(:receipt, title: 'テストタイトル') }

  before do
    sign_in admin_user
    receipt
  end

  describe 'GET /admin/receipts' do
    it 'リクエストが成功し、全ての受付が表示される' do
      get admin_receipts_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Web受付作品一覧')
      expect(response.body).to include('テストタイトル')
    end
  end

  describe 'GET /admin/receipts/:id' do
    it 'リクエストが成功し、指定された受付が表示される' do
      get admin_receipt_path(receipt.id)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('申請内容詳細')
      expect(response.body).to include('テストタイトル')
    end
  end

  describe 'GET /admin/receipts/:id/edit' do
    context '受付が未発注の場合' do
      it 'リクエストが成功し、編集画面が表示される' do
        get edit_admin_receipt_path(receipt.id)

        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(admin_receipt_path(receipt))
        follow_redirect!
        expect(response.body).to include('申請内容詳細')
      end
    end

    context '受付が発注済みの場合' do
      let(:ordered_receipt) { create(:receipt, title: '発注済みタイトル', register_status: :ordered) }

      it 'リダイレクトされる' do
        get edit_admin_receipt_path(ordered_receipt.id)

        expect(response).to redirect_to(admin_receipt_path)
      end
    end
  end

  describe 'PATCH /admin/receipts/:id' do
    let(:worker) { create(:worker) }
    let(:person) { create(:person) }
    let(:valid_params) do
      {
        receipt: {
          title: '更新されたタイトル',
          title_kana: 'こうしんされたタイトルカナ',
          worker_id: worker.id,
          person_id: person.id,
          original_book_title: 'オリジナルタイトル',
          publisher: '出版社',
          first_pubdate: '2025-01-01',
          input_edition: '初版',
          last_name_kana: 'やまだ',
          last_name: '山田',
          first_name_kana: 'たろう',
          first_name: '太郎',
          kana_type_id: 1,
          started_on: '2025-01-02',
          work_status_id: 4,
          copyright_flag: true
        }
      }
    end

    let(:invalid_params) do
      {
        receipt: {
          title: nil # タイトルが必須だが欠けている
        }
      }
    end

    ## 未発注に上書き
    let(:receipt) { create(:receipt, :non_ordered, title: '未発注タイトル') }

    context '有効なパラメータの場合' do
      it '更新が成功し、リダイレクトされる' do
        patch admin_receipt_path(receipt.id), params: valid_params

        expect(response).to redirect_to(admin_receipt_path(receipt.id))
        follow_redirect!
        expect(response.body).to include('更新しました')
        expect(receipt.reload.title).to eq('更新されたタイトル')
      end
    end

    context '無効なパラメータの場合' do
      it '更新が失敗し、エラーメッセージが表示される' do
        patch admin_receipt_path(receipt.id), params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('入力エラーがあります')
        expect(receipt.reload.title).not_to eq(nil)
      end
    end

    context '受付が発注済みの場合' do
      let(:ordered_receipt) { create(:receipt, :ordered) }

      it 'リダイレクトされる' do
        patch admin_receipt_path(ordered_receipt.id), params: valid_params

        expect(response).to redirect_to(edit_admin_receipt_path(ordered_receipt.id))
      end
    end
  end
end
