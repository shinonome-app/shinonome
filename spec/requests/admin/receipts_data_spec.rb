# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Receipts Data Validation' do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /admin/receipts/:id/edit' do
    context 'when receipt has valid data for form initialization' do
      it 'loads the form with existing receipt data' do
        receipt = create(:receipt, :non_ordered)

        get edit_admin_receipt_path(receipt)

        expect(response).to have_http_status(:ok) # Shows edit form
        expect(response.body).to include(receipt.title)
      end
    end

    context 'when receipt is already ordered' do
      it 'redirects away from edit form' do
        receipt = create(:receipt, :ordered)

        get edit_admin_receipt_path(receipt)

        expect(response).to redirect_to(admin_receipt_path)
      end
    end
  end

  describe 'PATCH /admin/receipts/:id validation behavior' do
    context 'when receipt is already ordered' do
      it 'redirects without processing update' do
        receipt = create(:receipt, :ordered)

        patch admin_receipt_path(receipt), params: {
          receipt: { title: 'New Title' }
        }

        expect(response).to redirect_to(edit_admin_receipt_path(receipt))
        expect(receipt.reload.title).not_to eq('New Title')
      end
    end

    context 'when required fields are missing' do
      it 'returns unprocessable content status' do
        receipt = create(:receipt, :non_ordered)

        patch admin_receipt_path(receipt), params: {
          receipt: { title: nil } # Missing required fields
        }

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe 'Form object data validation' do
    context 'worker and person creation logic' do
      it 'allows worker_id -1 for new worker registration' do
        receipt = create(:receipt, :non_ordered, :without_worker)
        form = Admin::ReceiptForm.new({
                                        worker_id: -1,
                                        worker_name: 'Test Worker',
                                        worker_kana: 'テストワーカー'
                                      }, receipt: receipt)

        expect(form.worker_id).to eq(-1)
        worker, _secret = form.worker_and_worker_secret
        expect(worker.name).to eq('Test Worker')
        expect(worker).not_to be_persisted # New worker not saved yet
      end

      it 'allows person_id -1 for new person registration' do
        receipt = create(:receipt, :non_ordered, :without_person)
        form = Admin::ReceiptForm.new({
                                        person_id: -1,
                                        last_name: '新規',
                                        last_name_kana: 'シンキ',
                                        first_name: '人物',
                                        first_name_kana: 'ジンブツ',
                                        copyright_flag: false,
                                        person_note: 'テスト用メモ'
                                      }, receipt: receipt)

        person = form.find_or_create_person
        expect(person.last_name).to eq('新規')
        expect(person).to be_persisted # Person was created
      end

      it 'handles person_id 0 for anonymous author' do
        receipt = create(:receipt, :non_ordered, :without_person)
        form = Admin::ReceiptForm.new({ person_id: 0 }, receipt: receipt)

        person = form.find_or_create_person
        expect(person.id).to eq(0) # Returns existing person with id 0
        expect(person.last_name).to eq('著者なし') # Anonymous author
      end
    end
  end
end
