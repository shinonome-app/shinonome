# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofreadForm do
  # バリデーションのテスト
  describe 'validations' do
    let(:work) { create(:work, :teihon, :with_person, work_status_id: 5, title: '作品その1') }
    let(:work2) { create(:work, :with_person, work_status_id: 5, title: '作品その2') }
    let(:work3) { create(:work, :with_person, work_status_id: 5, title: '作品その3') }
    let(:proofread_form_params) do
      {
        sub_works_attributes: {
          '0' => {
            work_id: work.id,
            enabled: 1
          },
          '1' => {
            work_id: work2.id,
            enabled: 1
          },
          '2' => {
            work_id: work3.id,
            enabled: 0
          }
        },
        person_id: work.people.first.id,
        worker_name: 'worker_name',
        worker_kana: 'worker_kana',
        email: 'test@example.com',
        address: '東京都'
      }
    end

    let(:proofread_form) { ProofreadForm.new(proofread_form_params) }

    it '成功する場合' do
      expect(proofread_form).to be_valid
      expect(proofread_form.sub_works.count).to eq(2)
    end

    it 'worker_nameがない場合は無効' do
      proofread_form.worker_name = nil
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:worker_name]).to include('を入力してください')
    end

    it 'worker_kanaがない場合は無効' do
      proofread_form.worker_kana = nil
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:worker_kana]).to include('を入力してください')
    end

    it 'worker_idが空でemailもない場合は無効' do
      proofread_form.worker_id = nil
      proofread_form.email = nil
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:email]).to include('を入力してください')
    end

    it 'emailの形式が不正な場合は無効' do
      proofread_form.email = 'invalid-email'
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:email]).to include('は不正な値です')
    end

    it 'sub_worksが1つも選択されていない場合は無効' do
      proofread_form.sub_works = []
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:sub_works]).to include('1つ以上選択してください')
    end

    it '送付先が必要な場合にaddressが空の場合は無効' do
      sub_work = ProofreadForm::SubWork.new(work_id: work.id, work_copy: 1, work_print: 1)
      proofread_form.address = nil
      proofread_form.sub_works = [sub_work]
      expect(proofread_form).not_to be_valid
      expect(proofread_form.errors[:address]).to include('を入力してくだい（底本コピー、プリントアウトが必要な場合は「送付先」が必要となります）')
    end
  end

  # 作者からのフォーム生成のテスト
  describe '.new_by_author' do
    let(:person) { create(:person, last_name: '青空', first_name: '太郎', last_name_kana: 'あおぞら', first_name_kana: 'たろう', sortkey: 'あおぞら', sortkey2: 'たろう') }
    let(:work) { create(:work, :teihon, work_status_id: 5, title: '作品その1') }
    let(:work2) { create(:work, :teihon, work_status_id: 5, title: '作品その2') }

    before do
      create(:work_person, work:, person:)
      create(:work_person, work: work2, person:)
    end

    it 'personからProofreadFormを生成する' do
      form = ProofreadForm.new_by_author(person)

      expect(form.person_id).to eq(person.id)
      expect(form.sub_works.count).to eq(2)
      expect(form.sub_works[0].work_id).to eq(work.id)
      expect(form.sub_works[1].work_id).to eq(work2.id)
    end
  end

  # 保存のテスト
  describe '#save' do
    let(:worker) { create(:worker, name: 'テストワーカー', name_kana: 'テストカナ') }
    let(:worker_secret) { create(:worker_secret, worker:, email: 'worker@example.com') }
    let(:work) { create(:work, :teihon, :with_person, title: 'タイトル') }
    let(:params) do
      {
        address: '東京都',
        email: 'test@example.com',
        memo: 'メモ',
        url: 'http://example.com',
        worker_kana: 'カナ',
        worker_name: 'テストワーカー',
        person_id: work.first_author.id,
        worker_id: worker.id,
        sub_works_attributes: {
          '0' => { work_id: work.id, work_copy: 1, work_print: 1, proof_edition: '初版', enabled: true }
        }
      }
    end

    let(:form) { ProofreadForm.new(params) }

    it '有効なsub_worksを保存する' do
      expect { form.save }.to change(Proofread, :count).by(1)
    end

    it '無効な場合は保存しない' do
      form.worker_id = nil
      form.worker_name = nil
      expect(form.save).to be_falsey
    end

    context 'worker_secretが存在しないworkerの場合' do
      let(:worker_without_secret) do
        # worker_secretなしでworkerを作成
        worker = Worker.new(name: 'シークレットなし', name_kana: 'しーくれっとなし')
        worker.save(validate: false)
        worker
      end

      it 'set_emailでエラーにならない' do
        form.worker_id = worker_without_secret.id
        expect(form).to be_valid
        # saveしてもエラーにならないことを確認
        expect { form.save }.not_to raise_error
      end
    end
  end

  # SubWorkのテスト
  describe ProofreadForm::SubWork do
    let(:work) { create(:work, :teihon, title: 'テスト作品') }
    let(:sub_work) { ProofreadForm::SubWork.new(work_id: work.id, work_copy: 1, work_print: 0, proof_edition: '初版') }

    it 'work_idが存在する場合は有効' do
      expect(sub_work).to be_valid
    end

    it 'work_idがない場合は無効' do
      sub_work.work_id = nil
      expect(sub_work).not_to be_valid
      expect(sub_work.errors[:work_id]).to include('を入力してください')
    end

    it 'work_copy?が正しく判定される' do
      expect(sub_work.work_copy?).to be true
    end

    it 'work_print?が正しく判定される' do
      expect(sub_work.work_print?).to be false
    end

    it 'workを正しく取得できる' do
      expect(sub_work.work.title).to eq('テスト作品')
    end
  end
end
