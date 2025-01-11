# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiptForm do
  # ReceiptFormのバリデーションテスト
  describe 'validations' do
    let(:worker) { create(:worker, name: 'テストワーカー保存済み', name_kana: 'テストカナホゾンズミ') }
    let(:params) do
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

    let(:form) { ReceiptForm.new(params) }

    it '必要な項目が全て揃っている場合は有効' do
      expect(form).to be_valid
    end

    it 'worker_kanaがない場合は登録済みの情報が使われる' do
      form.worker_kana = nil
      expect(form).to be_valid
      expect(form.worker_kana).to eq 'テストカナホゾンズミ'
    end

    it 'worker_nameがない場合は登録済みの情報が使われる' do
      form.worker_name = nil
      expect(form).to be_valid
      expect(form.worker_name).to eq 'テストワーカー保存済み'
    end

    it 'original_book_titleがない場合は無効' do
      form.original_book_title = nil
      expect(form).not_to be_valid
      expect(form.errors[:original_book_title]).to include("を入力してください")
    end

    it 'worker_idが無効な場合は無効' do
      form.worker_id = 9999
      expect(form).not_to be_valid
      expect(form.errors[:worker_id]).to include("は不正な値です")
    end

    it 'emailがない場合、worker_idが必要' do
      form.email = nil
      form.worker_id = nil
      expect(form).not_to be_valid
      expect(form.errors[:email]).to include("を入力してください")
    end

    it 'sub_worksが無効な場合はエラーを追加' do
      params[:sub_works_attributes]['0'][:title] = nil
      params[:sub_works_attributes]['0'][:title_kana] = nil

      expect(form).not_to be_valid
      expect(form.errors.full_messages).to include("作品1の作品名を入力してください")
      expect(form.errors.full_messages).to include("作品1の作品名読みを入力してください")
    end
  end

  # saveメソッドのテスト
  describe '#save' do
    let(:worker) { create(:worker, name: 'テストワーカー', name_kana: 'テストカナ') }
    let(:params) do
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

    let(:form) { ReceiptForm.new(params) }

    it '有効な場合はReceiptを保存する' do
      expect { form.save }.to change(Receipt, :count).by(1)
    end

    it '無効な場合は保存しない' do
      form.worker_id = nil
      form.email = nil
      expect(form.save).to be false
    end
  end

  # SubWorkのテスト
  describe ReceiptForm::SubWork do
    let(:kana_type) { KanaType.find(1) }
    let(:sub_work) { ReceiptForm::SubWork.new(title_kana: 'タイトルカナ', title: 'タイトル', kana_type_id: kana_type.id, copyright_flag: 1) }

    it 'title_kanaとtitleが存在する場合は有効' do
      expect(sub_work).to be_valid
    end

    it 'title_kanaがない場合は無効' do
      sub_work.title_kana = nil
      expect(sub_work).not_to be_valid
      expect(sub_work.errors[:title_kana]).to include("を入力してください")
    end

    it 'kana_type_idが範囲外の場合は無効' do
      sub_work.kana_type_id = 999
      expect(sub_work).not_to be_valid
      expect(sub_work.errors[:kana_type_id]).to include("は一覧にありません")
    end

    it 'copyright_flagが範囲外の場合は無効' do
      sub_work.copyright_flag = 2
      expect(sub_work).not_to be_valid
      expect(sub_work.errors[:copyright_flag]).to include("は一覧にありません")
    end

    it 'title_and_subtitleが正しく生成される' do
      sub_work.subtitle = 'サブタイトル'
      expect(sub_work.title_and_subtitle).to eq('タイトル　サブタイトル')
    end

    it 'kana_type_nameが正しく取得される' do
      expect(sub_work.kana_type_name).to eq('旧字旧仮名')
    end

    it 'copyright_flag_nameが正しく取得される' do
      expect(sub_work.copyright_flag_name).to eq('あり')
    end
  end
end
