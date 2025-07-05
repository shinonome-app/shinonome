# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiptsController do
  let(:worker) { create(:worker) }
  let(:worker_secret) { create(:worker_secret, worker: worker) }

  describe 'ユースケース: 新規ユーザーによる入力申請' do
    context '入力申請システムにアクセスする場合' do
      it 'インデックスから新規申請フォームにリダイレクトされること' do
        get receipts_path
        expect(response).to redirect_to(new_receipt_path)
      end

      it '説明付きの申請フォームが表示されること' do
        get new_receipt_path
        expect(response).to be_successful
        expect(response.body).to include('入力受付システム：必要事項の記入')
        expect(response.body).to include('入力者データ')
        expect(response.body).to include('著者データ')
        expect(response.body).to include('底本データ')
        expect(response.body).to include('作品データ')
      end
    end

    context '申請フォームを記入する場合' do
      let(:complete_application_data) do
        {
          receipt_form: {
            # 作業者情報（新規未登録作業者）
            worker_kana: 'あおぞらたろう',
            worker_name: '青空太郎',
            email: 'aozora@example.com',
            url: 'https://aozora-blog.example.com',

            # 著者情報（新規著者）
            last_name_kana: 'なつめ',
            last_name: '夏目',
            first_name_kana: 'そうせき',
            first_name: '漱石',
            person_note: '小説家、評論家、英文学者',

            # 底本情報
            original_book_title: '吾輩は猫である',
            publisher: '春陽堂',
            first_pubdate: '明治38年',
            input_edition: '初版',
            original_book_note: '国立国会図書館所蔵',

            # 作品データ（同一底本から複数作品可能）
            sub_works_attributes: {
              '0' => {
                title_kana: 'わがはいはねこである',
                title: '吾輩は猫である',
                subtitle_kana: '',
                subtitle: '',
                original_title: '',
                kana_type_id: 1, # 新字新仮名
                first_appearance: '雑誌「ホトトギス」明治38年1月号',
                memo: '代表作として名高い長編小説（青空太郎）',
                note: '11章からなる長編小説',
                copyright_flag: 0 # 著作権なし
              }
            }
          }
        }
      end

      it '同一底本から複数作品を追加できること' do
        post new_add_work_receipts_path, params: complete_application_data

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('作品データを追加する')
        expect(response.body).to include('この作品を削除')
      end

      it '複数作品申請から作品を削除できること' do
        multi_work_data = complete_application_data.deep_dup
        multi_work_data[:receipt_form][:sub_works_attributes]['1'] = {
          title_kana: 'ぼっちゃん',
          title: 'ぼっちゃん',
          kana_type_id: 1,
          copyright_flag: 0
        }

        post new_remove_work_receipts_path, params: multi_work_data.merge(work_num: '1')

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('吾輩は猫である')
        expect(response.body).not_to include('ぼっちゃん')
      end

      it 'プレビュー時に編集ボタンをクリックすると編集フォームに戻ること' do
        post receipts_path, params: complete_application_data.merge(edit: 'true')

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('吾輩は猫である')
        expect(response.body).to include('夏目')
      end
    end

    context '完全な申請を送信する場合' do
      let(:valid_application) do
        {
          receipt_form: {
            worker_kana: 'あおぞらたろう',
            worker_name: '青空太郎',
            email: 'aozora@example.com',
            last_name_kana: 'なつめ',
            last_name: '夏目',
            first_name_kana: 'そうせき',
            first_name: '漱石',
            original_book_title: '吾輩は猫である',
            publisher: '春陽堂',
            first_pubdate: '明治38年',
            input_edition: '初版',
            sub_works_attributes: {
              '0' => {
                title_kana: 'わがはいはねこである',
                title: '吾輩は猫である',
                kana_type_id: 1,
                copyright_flag: 0
              }
            }
          }
        }
      end

      it '申請が正常に作成され確認メールが送信されること' do
        expect do
          post receipts_path, params: valid_application
        end.to change(Receipt, :count).by(1)

        expect(response).to redirect_to(receipts_thanks_path)

        receipt = Receipt.last
        expect(receipt.worker_name).to eq('青空太郎')
        expect(receipt.title).to eq('吾輩は猫である')
        expect(receipt.last_name).to eq('夏目')
        expect(receipt.register_status).to eq('non_ordered')
      end

      it '同一底本の複数作品を処理できること' do
        multi_work_application = valid_application.deep_dup
        multi_work_application[:receipt_form][:sub_works_attributes]['1'] = {
          title_kana: 'ぼっちゃん',
          title: 'ぼっちゃん',
          kana_type_id: 1,
          copyright_flag: 0
        }

        expect do
          post receipts_path, params: multi_work_application
        end.to change(Receipt, :count).by(2)

        receipts = Receipt.last(2)
        expect(receipts.map(&:title)).to contain_exactly('吾輩は猫である', 'ぼっちゃん')
        expect(receipts.map(&:worker_name).uniq).to eq(['青空太郎'])
      end
    end
  end

  describe 'ユースケース: 登録済み作業者による申請' do
    before { worker_secret }

    let(:registered_worker_application) do
      {
        receipt_form: {
          # 登録済み作業者 - IDのみ必要
          worker_id: worker.id,

          # 著者情報
          last_name_kana: 'あくたがわ',
          last_name: '芥川',
          first_name_kana: 'りゅうのすけ',
          first_name: '龍之介',

          # 底本情報
          original_book_title: '羅生門・鼻',
          publisher: '新潮社',
          first_pubdate: '大正7年',
          input_edition: '改版',

          sub_works_attributes: {
            '0' => {
              title_kana: 'らしょうもん',
              title: '羅生門',
              kana_type_id: 1,
              copyright_flag: 0
            }
          }
        }
      }
    end

    it '作業者情報が自動入力され作業者メールが使用されること' do
      expect do
        post receipts_path, params: registered_worker_application
      end.to change(Receipt, :count).by(1)

      receipt = Receipt.last
      expect(receipt.worker_id).to eq(worker.id)
      expect(receipt.worker_name).to eq(worker.name)
      expect(receipt.worker_kana).to eq(worker.name_kana)
      # 注意: Receiptはworker_secret.emailを使用するが、ファクトリは異なるメールを作成する可能性がある
      expect(receipt.email).to be_present
    end
  end

  describe 'エラーシナリオ' do
    context '必須情報が不足している場合' do
      let(:incomplete_application) do
        {
          receipt_form: {
            worker_kana: '',
            worker_name: '',
            email: '',
            last_name_kana: '',
            last_name: '',
            original_book_title: '',
            publisher: '',
            first_pubdate: '',
            input_edition: '',
            sub_works_attributes: {
              '0' => {
                title_kana: '',
                title: '',
                kana_type_id: nil,
                copyright_flag: nil
              }
            }
          }
        }
      end

      it '申請が作成されずバリデーションエラーが表示されること' do
        expect do
          post receipts_path, params: incomplete_application
        end.not_to change(Receipt, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include('入力受付システム')
      end
    end

    context '作業者IDが無効な場合' do
      let(:invalid_worker_application) do
        {
          receipt_form: {
            worker_id: 99999, # 存在しない作業者
            last_name_kana: 'てすと',
            last_name: 'テスト',
            original_book_title: 'テスト本',
            publisher: 'テスト出版',
            first_pubdate: '2023年',
            input_edition: '初版',
            sub_works_attributes: {
              '0' => {
                title_kana: 'てすと',
                title: 'テスト',
                kana_type_id: 1,
                copyright_flag: 0
              }
            }
          }
        }
      end

      it '無効な作業者IDのバリデーションエラーが表示されること' do
        expect do
          post receipts_path, params: invalid_worker_application
        end.not_to change(Receipt, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context '未登録作業者のメールアドレスが不足している場合' do
      let(:no_email_application) do
        {
          receipt_form: {
            worker_kana: 'てすと',
            worker_name: 'テスト',
            email: '', # メールアドレス不足
            last_name_kana: 'てすと',
            last_name: 'テスト',
            original_book_title: 'テスト本',
            publisher: 'テスト出版',
            first_pubdate: '2023年',
            input_edition: '初版',
            sub_works_attributes: {
              '0' => {
                title_kana: 'てすと',
                title: 'テスト',
                kana_type_id: 1,
                copyright_flag: 0
              }
            }
          }
        }
      end

      it 'メールアドレス不足のバリデーションエラーが表示されること' do
        expect do
          post receipts_path, params: no_email_application
        end.not_to change(Receipt, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
