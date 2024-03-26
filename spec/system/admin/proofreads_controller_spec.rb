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

        proofread.reload
        expect(proofread.assigned?).to be(true)
        expect(proofread.ordered?).to be(false)
      end

      it '再検索前に底本情報を更新するとそれが反映される' do
        work = create(:work, :with_person, work_status_id: 5)
        original_book = create(:original_book, work:)
        original_book2 = create(:original_book, work:, booktype_id: 2)
        proofread = create(:proofread, :non_ordered, work:, worker: nil)

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        fill_in '底本名', with: '更新底本1'
        fill_in '出版社名', with: '更新出版社名1'
        fill_in '初版発行年', with: '更新初版発行年1'
        fill_in '入力に使用した版', with: '更新入力に使用した版1'
        fill_in '校正に使用する版', with: '更新校正に使用する版1'
        fill_in '底本の親本名', with: '更新底本2'
        fill_in '底本の親本出版社名', with: '更新出版社名2'
        fill_in '底本の親本初版発行年', with: '更新初版発行年2'
        choose '上記の内容で工作員を新規登録する'
        click_on('再検索')
        click_on('関連付ける')
        expect(page).to have_content('更新しました')

        original_book.reload
        original_book2.reload
        expect(original_book.title).to eq '更新底本1'
        expect(original_book.publisher).to eq '更新出版社名1'
        expect(original_book.first_pubdate).to eq '更新初版発行年1'
        expect(original_book.input_edition).to eq '更新入力に使用した版1'
        expect(original_book.proof_edition).to eq '更新校正に使用する版1'
        expect(original_book2.title).to eq '更新底本2'
        expect(original_book2.publisher).to eq '更新出版社名2'
        expect(original_book2.first_pubdate).to eq '更新初版発行年2'
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

        expect(proofread.assigned?).to be(true)
        expect(proofread.ordered?).to be(false)
      end
    end

    context '工作員が指定されている場合' do
      it 'すでに工作員が設定されている' do
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker)
        original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        expect(page).to have_content('申請内容確認')
        expect(page).to have_no_content('再検索')
        expect(page).to have_content(worker.name)
        expect(page).to have_content(worker.id)
        expect(page).to have_field('admin_proofread_form_original_book_title', with: original_book.title)
      end

      it 'そのまま登録できる' do
        work = create(:work, :with_person, work_status_id: 5)
        worker = create(:worker)
        _original_book = create(:original_book, work:)
        proofread = create(:proofread, :non_ordered, work:, worker:)

        visit '/admin/proofreads'

        click_on(proofread.work.title)
        click_on('関連付ける')
        expect(page).to have_content('Web校正受付管理')
        expect(page).to have_content('Web受付作品一覧')
        expect(page).to have_content('更新しました')
        expect(page).to have_content(proofread.worker_name)

        proofread.reload
        expect(worker.id).to eq proofread.worker_id

        # 申請の工作員名等は指定された工作員の名前と異なっていても修正されない
        expect(proofread.worker_name).not_to eq worker.name
        expect(proofread.worker_kana).not_to eq worker.name_kana

        expect(proofread.assigned?).to be(true)
        expect(proofread.ordered?).to be(false)
      end
    end
  end
end
