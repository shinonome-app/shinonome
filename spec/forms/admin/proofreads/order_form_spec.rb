# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Proofreads::OrderForm do
  let(:work) { create(:work, :teihon) }
  let(:proofread) { create(:proofread, work:) }
  let(:params) { { work_id: work.id, mail_memo: 'Test memo' } }

  describe '#initialize' do
    context 'with valid params' do
      it 'assigns attributes correctly' do
        form = Admin::Proofreads::OrderForm.new(params, proofread:)
        expect(form.work_id).to eq(params[:work_id])
        expect(form.mail_memo).to eq(params[:mail_memo])
      end
    end

    context 'with nil params' do
      it 'assigns default values to attributes' do
        form = Admin::Proofreads::OrderForm.new(nil, proofread: proofread)
        expect(form.mail_memo).to eq('')
      end
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      expect(form).to be_valid
    end

    it 'is invalid without work_id' do
      params[:work_id] = nil
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      expect(form).not_to be_valid
      expect(form.errors[:work_id]).to include('を入力してください')
    end

    it 'is invalid without mail_memo' do
      params[:mail_memo] = nil
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      expect(form).not_to be_valid
      expect(form.errors[:mail_memo]).to include('を入力してください')
    end
  end

  describe '#send!' do
    it 'transitions the proofread to ordered and updates the work status' do
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      form.send!
      expect(proofread.ordered?).to eq true
      expect(work.work_status_id).to eq 9 # 校正中	proofreading
    end

    it 'sends an order email' do
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      perform_enqueued_jobs do
        form.send!
      end

      expect(ActionMailer::Base.deliveries.count).to eq(1)
    end

    it 'raises an error if a transaction fails' do
      allow(proofread).to receive(:ordered!).and_raise(ActiveRecord::RecordInvalid)
      form = Admin::Proofreads::OrderForm.new(params, proofread: proofread)
      expect { form.send! }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
