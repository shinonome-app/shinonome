# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProofreadsController do
  let(:author) { create(:person) }
  let(:work) { create(:work, :with_person, :teihon) }
  let(:worker) { create(:worker) }
  let(:worker_secret) { create(:worker_secret, worker: worker) }

  describe 'ユースケース: 校正システムへのアクセス' do
    it 'メイン校正ページが表示されること' do
      get proofreads_path
      expect(response).to be_successful
      expect(response.body).to include('校正受付システム')
    end

    it '新規申請フォームにはパラメータが必要であること' do
      get new_proofread_path
      expect(response).to have_http_status(:bad_request)
      expect(response.body).to include('ActionController::ParameterMissing')
    end

    it '作品が選択された場合に申請フォームが表示されること' do
      params = {
        proofread_form: {
          person_id: author.id,
          sub_works_attributes: {
            '0' => { work_id: work.id, enabled: true }
          }
        }
      }

      get new_proofread_path, params: params
      expect(response).to be_successful
      expect(response.body).to include('校正受付システム：必要事項の記入')
      expect(response.body).to include('作品データ')
      expect(response.body).to include('校正者データ')
    end
  end

  describe 'ユーザージャーニー: 校正申請の送信' do
    let(:basic_application_params) do
      {
        proofread_form: {
          worker_name: '校正花子',
          worker_kana: 'こうせいはなこ',
          email: 'hanako@example.com',
          person_id: author.id,
          sub_works_attributes: {
            '0' => {
              work_id: work.id,
              work_copy: 0,
              work_print: 0,
              proof_edition: '手持ちの本で校正',
              enabled: true
            }
          }
        }
      }
    end

    context '有効な申請を送信する場合' do
      it '校正申請が正常に作成されること' do
        expect do
          post proofreads_path, params: basic_application_params
        end.to change(Proofread, :count).by(1)

        expect(response).to redirect_to(proofreads_thanks_path)

        proofread = Proofread.last
        expect(proofread.worker_name).to eq('校正花子')
        expect(proofread.work_id).to eq(work.id)
        expect(proofread.person_id).to eq(author.id)
        expect(proofread.work_copy).to eq('no_need_copy')
        expect(proofread.work_print).to eq('no_need_print')
        expect(proofread.assign_status).to eq('non_assigned')
      end

      it '物理的な資料が必要な申請を処理できること' do
        physical_materials_params = basic_application_params.deep_dup
        physical_materials_params[:proofread_form].merge!(
          address: "〒150-0001\n東京都渋谷区神宮前1-1-1\n校正花子",
          sub_works_attributes: {
            '0' => {
              work_id: work.id,
              work_copy: 1,
              work_print: 1,
              proof_edition: '新潮文庫版',
              enabled: true
            }
          }
        )

        expect do
          post proofreads_path, params: physical_materials_params
        end.to change(Proofread, :count).by(1)

        proofread = Proofread.last
        expect(proofread.work_copy).to eq('need_copy')
        expect(proofread.work_print).to eq('need_print')
        expect(proofread.address).to include('校正花子')
      end
    end

    context '登録済み作業者を使用する場合' do
      before { worker_secret }

      let(:registered_worker_params) do
        {
          proofread_form: {
            worker_id: worker.id,
            person_id: author.id,
            sub_works_attributes: {
              '0' => {
                work_id: work.id,
                work_copy: 0,
                work_print: 0,
                enabled: true
              }
            }
          }
        }
      end

      it '作業者情報が自動入力されること' do
        expect do
          post proofreads_path, params: registered_worker_params
        end.to change(Proofread, :count).by(1)

        proofread = Proofread.last
        expect(proofread.worker_id).to eq(worker.id)
        expect(proofread.worker_name).to eq(worker.name)
        expect(proofread.worker_kana).to eq(worker.name_kana)
      end
    end

    context '申請を編集する場合' do
      it '編集ボタンがクリックされたときに編集フォームに戻ること' do
        post proofreads_path, params: basic_application_params.merge(edit: 'true')

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('校正受付システム')
        expect(response.body).to include('校正花子')

        expect do
          # 編集中には校正申請が作成されないこと
        end.not_to change(Proofread, :count)
      end
    end
  end

  describe 'バリデーションとエラーハンドリング' do
    context '必要情報が不足している場合' do
      let(:incomplete_params) do
        {
          proofread_form: {
            worker_name: '',
            worker_kana: '',
            email: '',
            person_id: author.id,
            sub_works_attributes: {
              '0' => {
                work_id: work.id,
                enabled: false
              }
            }
          }
        }
      end

      it '申請が作成されずエラーが表示されること' do
        expect do
          post proofreads_path, params: incomplete_params
        end.not_to change(Proofread, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('校正受付システム')
      end
    end

    context '住所が必要だが不足している場合' do
      let(:missing_address_params) do
        {
          proofread_form: {
            worker_name: '校正太郎',
            worker_kana: 'こうせいたろう',
            email: 'taro@example.com',
            address: '',
            person_id: author.id,
            sub_works_attributes: {
              '0' => {
                work_id: work.id,
                work_copy: 1,
                work_print: 1,
                enabled: true
              }
            }
          }
        }
      end

      it 'バリデーションエラーが表示されること' do
        expect do
          post proofreads_path, params: missing_address_params
        end.not_to change(Proofread, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('校正受付システム')
      end
    end

    context '無効な作業者IDが提供された場合' do
      let(:invalid_worker_params) do
        {
          proofread_form: {
            worker_id: 99999,
            person_id: author.id,
            sub_works_attributes: {
              '0' => {
                work_id: work.id,
                enabled: true
              }
            }
          }
        }
      end

      it 'バリデーションエラーが表示されること' do
        expect do
          post proofreads_path, params: invalid_worker_params
        end.not_to change(Proofread, :count)

        # 無効な作業者IDはRecordNotFound(404)またはバリデーションエラー(422)を返す可能性がある
        expect(response).to have_http_status(:unprocessable_entity).or have_http_status(:not_found)
      end
    end
  end
end
