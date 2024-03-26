# frozen_string_literal: true

require 'rails_helper'

describe Admin::ProofreadsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    it '一覧に表示される' do
      work = create(:work, :with_person, work_status_id: 5)
      proofread = create(:proofread, :non_ordered, work:)

      visit '/admin/proofreads'

      expect(page).to have_content('Web校正受付管理')
      expect(page).to have_content('Web受付作品一覧')
      expect(page).to have_content('1件の作品が見つかりました。')
      expect(page).to have_content(proofread.work.title)
      expect(page).to have_content(proofread.work.kana_type_name)
      expect(page).to have_content(proofread.work.author_text)
      expect(page).to have_content(proofread.worker_name)
      expect(page).to have_content('未')
    end
  end

  describe '#edit' do
    context '工作員を新規登録する場合' do
      it '対象の申請が一覧に表示される' do
        work = create(:work, :with_person, work_status_id: 5)
        original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker: nil)

        visit '/admin/proofreads'

        click_on(proofread.work.title)

        expect(page).to have_content('申請内容確認')
        expect(page).to have_content('選択された作品')
        expect(page).to have_content(proofread.work.title)
        expect(page).to have_content(proofread.work.author_text)
        expect(page).to have_content(proofread.work.id)

        expect(page).to have_field('admin_proofread_form_original_book_title', with: original_book.title)
        # expect(page).to have_field('出版社名', with: original_book.publisher)
      end

      it '工作員を新規登録して再検索すると-1の値が設定される' do
        work = create(:work, :with_person, work_status_id: 5)
        original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker: nil)

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        choose '上記の内容で工作員を新規登録する'
        click_on('再検索')
        expect(page).to have_content('申請内容確認')
        expect(page).to have_content(proofread.worker_name)
        expect(page).to have_content('-1')
        expect(page).to have_field('admin_proofread_form_original_book_title', with: original_book.title)
      end

      it '再検索後そのまま登録すると新しい工作員が登録される' do
        work = create(:work, :with_person, work_status_id: 5)
        _original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker: nil)

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        choose '上記の内容で工作員を新規登録する'
        click_on('再検索')
        click_on('関連付ける')
        expect(page).to have_content('Web校正受付管理')
        expect(page).to have_content('Web受付作品一覧')
        expect(page).to have_content('更新しました')
        expect(page).to have_content(proofread.worker_name)

        worker = Worker.last
        expect(worker.name).to eq proofread.worker_name
        expect(worker.name_kana).to eq proofread.worker_kana
        expect(worker.sortkey).to eq Kana.convert_sortkey(proofread.worker_kana)
        expect(worker.updated_by).to eq user.id
      end
    end

    context '既存の工作員を適用する場合' do
      it '工作員を新規登録して再検索すると-1の値が設定される' do
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker: nil, worker_name: '青空太郎')

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        choose worker.name
        click_on('再検索')
        expect(page).to have_content('申請内容確認')
        expect(page).to have_content(proofread.worker_name)
        expect(page).to have_content(worker.id)
        expect(page).to have_field('admin_proofread_form_original_book_title', with: original_book.title)
      end

      it '再検索後そのまま登録すると新しい工作員が登録される' do
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker, name: '青空太郎')
        _original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker: nil, worker_name: '青空太郎')

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        choose worker.name
        click_on('再検索')
        click_on('関連付ける')
        expect(page).to have_content('Web校正受付管理')
        expect(page).to have_content('Web受付作品一覧')
        expect(page).to have_content('更新しました')
        expect(page).to have_content(proofread.worker_name)

        new_worker = Worker.last
        proofread.reload
        expect(new_worker.id).to eq worker.id
        expect(new_worker.id).to eq proofread.worker_id
      end
    end
  end
end
