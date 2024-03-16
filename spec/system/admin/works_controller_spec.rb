# frozen_string_literal: true

require 'rails_helper'

describe Admin::WorksController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    it '一覧画面が表示される' do
      visit '/admin/works'

      expect(page).to have_content('作品検索')
      expect(page).to have_content('作品50音順インデックス')
      expect(page).to have_content('作品状態検索')
      expect(page).to have_content('著者別インデックス')
      expect(page).to have_content('著者不明作品検索')
      expect(page).to have_content('作品一覧')
    end
  end

  describe '#create' do
    context '何も入力しない場合' do
      it 'エラーになる' do
        visit '/admin/works/new'
        click_on('登録する')
        expect(page).to have_content('作品新規登録')
        expect(page).to have_content('入力エラーがあります')
        expect(page).to have_content('仮名遣い種別を入力してください')
        expect(page).to have_content('状態を入力してください')
        expect(page).to have_content('作品名読みを入力してください')
        expect(page).to have_content('作品名を入力してください')
      end
    end

    context '作品新規登録画面から一通り入力した場合' do
      it '登録される' do
        visit '/admin/works/new'

        fill_in '作品名読み', with: 'さくひんてすといち'
        fill_in 'ソート用読み', with: 'さくひんてすといち'
        fill_in '作品名', with: '作品テスト1'
        select '新字新仮名', from: '仮名遣い種別'
        fill_in '初出', with: '初出1'
        fill_in '作品について', with: '作品について1'
        fill_in '底本管理情報(非公開)', with: '底本管理情報1'
        fill_in '備考(非公開)', with: '備考1'
        select '入力予約', from: '状態'
        # '状態の開始日'
        select '2023', from: 'work_started_on_1i'
        select '3', from: 'work_started_on_2i'
        select '23', from: 'work_started_on_3i'
        select 'なし', from: '著作権フラグ'

        click_on('登録する')
        expect(page).to have_content('追加しました')
        expect(page).to have_content('作品データ')

        work_id = find('th', text: '作品ID').sibling('td').text

        expect(page).to have_current_path admin_work_path(id: work_id), ignore_query: true

        work = Work.find(work_id)
        expect(work.title_kana).to eq 'さくひんてすといち'
        expect(work.sortkey).to eq 'さくひんてすといち'
        expect(work.title).to eq '作品テスト1'
        expect(work.first_appearance).to eq '初出1'
        expect(work.description).to eq '作品について1'
        expect(work.work_status.name).to eq '入力予約'
        expect(work.kana_type_name).to eq '新字新仮名'
        expect(work.copyright_flag).to eq false
        expect(work.started_on.to_fs(:db)).to eq '2023-03-23'
        expect(work.work_secret.orig_text).to eq '底本管理情報1'
        expect(work.work_secret.memo).to eq '備考1'
        expect(work.user_id).to eq user.id
      end
    end
  end

  describe '#delete' do
    let(:work) { create(:work, title: '作品その1') }

    it '作品データで削除をクリックすると削除される' do
      visit "/admin/works/#{work.id}"

      expect(page).to have_content('作品データ')
      expect(page).to have_content('作品その1')

      page.find('snm-headline', text: '作品データ').sibling('div').click_on('削除')
      expect do
        expect(page.accept_confirm).to eq '本当に削除しますか?'
        expect(page).to have_content '削除しました'
      end.to change(Work, :count).by(-1)

      expect(Work.where(id: work.id).first).to eq nil
    end
  end
end
