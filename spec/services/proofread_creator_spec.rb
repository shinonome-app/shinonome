# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofreadCreator do
  describe '#create_proofread' do
    let(:work) { create(:work, :teihon, :with_person) }
    let(:proofread_params) do
      {
        address: '東京都',
        email: 'test@example.com',
        memo: 'メモ',
        url: 'http://example.com',
        worker_kana: 'カナ',
        worker_name: 'テストワーカー',
        person_id: work.first_author.id,
        sub_works_attributes: {
          '0' => { work_id: work.id, work_copy: 1, work_print: 1, proof_edition: '初版', enabled: true }
        }
      }
    end

    let(:result) { ProofreadCreator.new.create_proofread(proofread_params) }

    context 'フォームが有効な場合' do
      it 'フォームを保存する' do
        expect { result }.to change(Proofread, :count).by(1)
      end

      it 'メールを送信する' do
        ActionMailer::Base.deliveries.clear
        perform_enqueued_jobs do
          result
        end
        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end

      it '成功した結果を返す' do
        expect(result).to be_created
        expect(result.proofreads.count).to eq(1)
        proofread = result.proofreads.first
        expect(proofread.worker_kana).to eq('カナ')
        expect(proofread.worker_name).to eq('テストワーカー')
        expect(proofread.work.id).to eq(work.id)
        expect(proofread.work_copy).to eq('need_copy')
        expect(proofread.worker).to be_nil # 登録後も変わらない
      end
    end

    context 'フォームが無効な場合' do
      before do
        proofread_params[:email] = nil
      end

      it 'フォームを保存しない' do
        expect { result }.not_to change(Proofread, :count)
      end

      it 'メールを送信しない' do
        ActionMailer::Base.deliveries.clear
        perform_enqueued_jobs do
          result
        end
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end

      it '失敗した結果を返す' do
        expect(result).not_to be_created
        expect(result.proofreads).to be_nil
      end
    end

    context 'saveがnilを返す場合（データベースエラー）' do
      let(:proofread_form) { ProofreadForm.new(proofread_params) }

      before do
        allow(proofread_form).to receive(:save).and_return(nil)
        allow(ProofreadForm).to receive(:new).and_return(proofread_form)
      end

      it 'created?がfalseを返す' do
        expect(result).not_to be_created
      end

      it 'proofreadsがnilを返す' do
        expect(result.proofreads).to be_nil
      end

      it 'エラーメッセージが追加される' do
        expect(result.proofread_form.errors[:base]).to include('登録中にエラーが発生しました。しばらく経ってから再度お試しください。')
      end

      it 'メールを送信しない' do
        ActionMailer::Base.deliveries.clear
        perform_enqueued_jobs do
          result
        end
        expect(ActionMailer::Base.deliveries.count).to eq(0)
      end
    end
  end
end
