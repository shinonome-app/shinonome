# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ProofreadForm, type: :model do
  let(:work) { create(:work) }
  let(:proofread) { create(:proofread, work:) }
  let(:current_admin_user) { create(:user) }
  let(:worker) { create(:worker) }
  let(:another_worker) { create(:worker) }
  let(:params) do
    {
      work_id: work.id,
      worker_id: another_worker.id,
      worker_kana: 'カナ',
      worker_name: 'テストワーカー',
      email: 'test@example.com',
      url: 'http://example.com',
      address: '東京都',
      memo: 'メモ',
      original_book_title: 'タイトル1',
      publisher: '出版社1',
      first_pubdate: '2025-01-01',
      input_edition: '初版',
      proof_edition: '校正版',
      original_book_title2: 'タイトル2',
      publisher2: '出版社2',
      first_pubdate2: '2025-01-02'
    }
  end

  describe '#initialize' do
    context '正しい情報+存在するworkerのidの場合' do
      it 'assigns attributes correctly' do
        form = Admin::ProofreadForm.new(params, proofread:, current_admin_user:)
        expect(form.work_id).to eq(work.id)
        # 入力した情報ではなくworkerの情報が使われる
        expect(form.worker_kana).not_to eq('カナ')
        expect(form.worker_name).not_to eq('テストワーカー')
        expect(form.worker_kana).to eq(another_worker.name_kana)
        expect(form.worker_name).to eq(another_worker.name)
        expect(form.email).to eq('test@example.com')
        expect(form.url).to eq('http://example.com')
        expect(form.address).not_to eq('東京都')
        expect(form.address).to eq(proofread.address)
        expect(form.memo).to eq('メモ')
        expect(form.original_book_title).to eq('タイトル1')
        expect(form.publisher).to eq('出版社1')
        expect(form.first_pubdate).to eq('2025-01-01')
        expect(form.input_edition).to eq('初版')
        expect(form.proof_edition).to eq('校正版')
        expect(form.original_book_title2).to eq('タイトル2')
        expect(form.publisher2).to eq('出版社2')
        expect(form.first_pubdate2).to eq('2025-01-02')
      end
    end

    context '正しい情報+worker_idがない場合' do
      it 'assigns attributes correctly' do
        params2 = params.dup
        params2[:worker_id] = nil
        form = Admin::ProofreadForm.new(params2, proofread:, current_admin_user:)
        expect(form.work_id).to eq(work.id)
        expect(form.worker_kana).to eq('カナ')
        expect(form.worker_name).to eq('テストワーカー')
        expect(form.email).to eq('test@example.com')
        expect(form.url).to eq('http://example.com')
        expect(form.address).not_to eq('東京都')
        expect(form.address).to eq(proofread.address)
        expect(form.memo).to eq('メモ')
        expect(form.original_book_title).to eq('タイトル1')
        expect(form.publisher).to eq('出版社1')
        expect(form.first_pubdate).to eq('2025-01-01')
        expect(form.input_edition).to eq('初版')
        expect(form.proof_edition).to eq('校正版')
        expect(form.original_book_title2).to eq('タイトル2')
        expect(form.publisher2).to eq('出版社2')
        expect(form.first_pubdate2).to eq('2025-01-02')
      end
    end

    context 'with nil params' do
      it 'assigns default values from proofread' do
        allow(work).to receive(:first_teihon)
        allow(work).to receive(:first_oyahon)
        form = Admin::ProofreadForm.new(nil, proofread:, current_admin_user:)
        expect(form.id).to eq(proofread.id)
        expect(form.work_id).to eq(proofread.work_id)
        expect(form.worker_id).to eq(proofread.worker_id)
      end
    end
  end

  describe 'validations' do
    let(:form) { Admin::ProofreadForm.new(params, proofread:, current_admin_user:) }

    it 'is valid with all required attributes' do
      expect(form).to be_valid
    end

    it 'is invalid without worker_kana' do
      form.worker_kana = nil
      expect(form).not_to be_valid
      expect(form.errors[:worker_kana]).to include('を入力してください')
    end

    it 'is invalid without worker_name' do
      form.worker_name = nil
      expect(form).not_to be_valid
      expect(form.errors[:worker_name]).to include('を入力してください')
    end

    it 'is invalid without original_book_title' do
      form.original_book_title = nil
      expect(form).not_to be_valid
      expect(form.errors[:original_book_title]).to include('を入力してください')
    end

    it 'is invalid without publisher' do
      form.publisher = nil
      expect(form).not_to be_valid
      expect(form.errors[:publisher]).to include('を入力してください')
    end

    it 'is invalid without first_pubdate' do
      form.first_pubdate = nil
      expect(form).not_to be_valid
      expect(form.errors[:first_pubdate]).to include('を入力してください')
    end

    it 'is invalid without input_edition' do
      form.input_edition = nil
      expect(form).not_to be_valid
      expect(form.errors[:input_edition]).to include('を入力してください')
    end

    it 'is invalid without worker_id' do
      form.worker_id = nil
      expect(form).not_to be_valid
      expect(form.errors[:worker_id]).to include('を入力してください')
    end

    it 'is invalid when email is blank and worker_id is nil' do
      form.email = nil
      form.worker_id = nil
      expect(form).not_to be_valid
      expect(form.errors[:email]).to include('を入力してください')
    end
  end

  describe '#save' do
    let(:worker) { create(:worker) }
    let(:proofread_associator) { ProofreadAssociator.new }
    let(:worker_finder) { WorkerFinder.new }

    before do
      allow(worker_finder).to receive(:find_with_form).and_return(worker)
      allow(WorkerFinder).to receive(:new).and_return(worker_finder)
      allow(ProofreadAssociator).to receive(:new).and_return(proofread_associator)
    end

    it 'saves the form successfully' do
      form = Admin::ProofreadForm.new(params, proofread: proofread, current_admin_user: current_admin_user)
      expect(form.save).to be true
    end

    it 'does not save the form if invalid' do
      params[:publisher] = nil
      form = Admin::ProofreadForm.new(params, proofread: proofread, current_admin_user: current_admin_user)
      expect(form.save).to be false
    end
  end
end
