# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceiptAssociator do
  describe '#associate_receipt' do
    let(:worker) { create(:worker, name: 'テストワーカー', name_kana: 'テストカナ') }
    let(:person) { create(:person, last_name: '山田', first_name: '太郎', last_name_kana: 'やまだ', first_name_kana: 'たろう') }
    let(:current_admin_user) { create(:user) }
    let(:receipt) { create(:receipt) }

    let(:receipt_form_params) do
      {
        worker_id: worker.id,
        worker_kana: 'テストカナ',
        worker_name: 'テストワーカー',
        email: 'test@example.com',
        original_book_title: '底本タイトル',
        publisher: '底本出版社',
        first_pubdate: '2020-01-01',
        input_edition: '初版',
        person_id: person.id,
        last_name_kana: person.last_name_kana,
        last_name: person.last_name,
        first_name_kana: person.first_name_kana,
        first_name: person.first_name,
        title: 'テストタイトル',
        title_kana: 'テストタイトルカナ',
        subtitle: 'サブタイトル',
        subtitle_kana: 'サブタイトルカナ',
        original_title: '原題',
        started_on: '2024-01-02',
        kana_type_id: 1,
        work_status_id: 5,
        copyright_flag: true,
      }
    end

    let(:receipt_form) { Admin::ReceiptForm.new(receipt_form_params, receipt:, current_admin_user:) }

    it '関連付けを正しく行う' do
      result = described_class.new.associate_receipt(
        worker:,
        person:,
        current_admin_user:,
        receipt_form:
      )

      expect(result).to be_associated

      # Workが正しく作成されていることを確認
      work = Work.find_by(title: 'テストタイトル')
      expect(work).not_to be_nil
      expect(work.title_kana).to eq('テストタイトルカナ')
      expect(work.subtitle).to eq('サブタイトル')
      expect(work.original_title).to eq('原題')
      expect(work.kana_type_id).to eq(1)
      expect(work.copyright_flag).to be(true)

      # WorkPersonが関連付けられていることを確認
      work_person = WorkPerson.find_by(work:, person:)
      expect(work_person).not_to be_nil

      # WorkWorkerが関連付けられていることを確認
      work_worker = WorkWorker.find_by(work:, worker:)
      expect(work_worker).not_to be_nil

      # OriginalBookが作成されていることを確認
      original_book = OriginalBook.find_by(work:, booktype_id: 1)
      expect(original_book).not_to be_nil
      expect(original_book.title).to eq('底本タイトル')
      expect(original_book.publisher).to eq('底本出版社')

      # Receiptが更新されていることを確認
      updated_receipt = Receipt.find(receipt.id)
      expect(updated_receipt.work_id).to eq(work.id)
      expect(updated_receipt.worker_id).to eq(worker.id)
      expect(updated_receipt.person_id).to eq(person.id)
      expect(updated_receipt.original_book_title).to eq('底本タイトル')
      expect(updated_receipt.register_status).to eq('ordered')
    end

    it '無効なデータの場合はロールバックする' do
      # titleをnilにして保存を失敗させる
      receipt_form.title = nil

      result = described_class.new.associate_receipt(
        worker:,
        person:,
        current_admin_user:,
        receipt_form:
      )

      expect(result).not_to be_associated

      # データベースに保存されていないことを確認
      expect(Work.count).to eq(0)
      expect(OriginalBook.count).to eq(0)
      expect(receipt.work_id).to be_nil
    end
  end
end
