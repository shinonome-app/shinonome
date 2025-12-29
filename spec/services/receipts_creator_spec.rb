# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiptsCreator do
  describe '#create_receipt' do
    subject(:creator) { ReceiptsCreator.new }

    let(:worker) { create(:worker, name: 'テストワーカー', name_kana: 'テストカナ') }
    let(:valid_params) do
      {
        worker_id: worker.id,
        worker_kana: 'テストカナ',
        worker_name: 'テストワーカー',
        email: 'test@example.com',
        original_book_title: 'オリジナルタイトル',
        publisher: '出版社',
        first_pubdate: '2025-01-01',
        input_edition: '初版',
        last_name_kana: 'やまだ',
        last_name: '山田',
        first_name_kana: 'たろう',
        first_name: '太郎',
        sub_works_attributes: {
          '0' => {
            title_kana: 'タイトルカナ',
            title: 'タイトル',
            kana_type_id: 1,
            copyright_flag: 0
          }
        }
      }
    end

    context '有効なパラメータの場合' do
      it 'Receiptを作成する' do
        expect { creator.create_receipt(valid_params) }.to change(Receipt, :count).by(1)
      end

      it 'created?がtrueを返す' do
        result = creator.create_receipt(valid_params)
        expect(result.created?).to be true
      end

      it 'receiptsが返される' do
        result = creator.create_receipt(valid_params)
        expect(result.receipts).to be_present
        expect(result.receipts.first).to be_a(Receipt)
      end

      it 'メールが送信される' do
        expect { creator.create_receipt(valid_params) }
          .to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { valid_params.merge(email: nil, worker_id: nil) }

      it 'Receiptを作成しない' do
        expect { creator.create_receipt(invalid_params) }.not_to change(Receipt, :count)
      end

      it 'created?がfalseを返す' do
        result = creator.create_receipt(invalid_params)
        expect(result.created?).to be false
      end

      it 'receiptsがnilを返す' do
        result = creator.create_receipt(invalid_params)
        expect(result.receipts).to be_nil
      end
    end

    context 'saveがnilを返す場合（データベースエラー）' do
      let(:receipt_form) { ReceiptForm.new(valid_params) }

      before do
        allow(receipt_form).to receive(:save).and_return(nil)
        allow(ReceiptForm).to receive(:new).and_return(receipt_form)
      end

      it 'created?がfalseを返す' do
        result = creator.create_receipt(valid_params)
        expect(result.created?).to be false
      end

      it 'receiptsがnilを返す' do
        result = creator.create_receipt(valid_params)
        expect(result.receipts).to be_nil
      end

      it 'エラーメッセージが追加される' do
        result = creator.create_receipt(valid_params)
        expect(result.receipt_form.errors[:base]).to include('登録中にエラーが発生しました。しばらく経ってから再度お試しください。')
      end

      it 'メールが送信されない' do
        expect { creator.create_receipt(valid_params) }
          .not_to(change { ActionMailer::Base.deliveries.count })
      end
    end
  end
end
