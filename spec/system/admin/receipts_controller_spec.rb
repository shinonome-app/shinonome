# frozen_string_literal: true

require 'rails_helper'

describe Admin::ReceiptsController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    it '一覧に表示される' do
      create(:receipt, :non_ordered)

      visit '/admin/receipts'

      expect(page).to have_content('Web入力受付管理')
      expect(page).to have_content('Web受付作品一覧')
      expect(page).to have_content('1件の作品が見つかりました。')
      expect(page).to have_content('作品その一')
      expect(page).to have_content('旧字旧仮名')
      expect(page).to have_content('青空 文子')
      expect(page).to have_content('耕作員6')
      expect(page).to have_content('未')
    end
  end

  describe '工作員の新規登録の申請受理' do
    before do
      Capybara.current_session.driver.browser.manage.window.resize_to(1280, 4000)
    end

    it '工作員IDが入力されていない場合、工作員名はフォームになる' do
      receipt = create(:receipt, :non_ordered, :without_worker)

      visit "/admin/receipts/#{receipt.id}/edit"
      expect(page).to have_content('申請内容確認')
      expect(page).to have_field('作品名', with: receipt.title)
      expect(page).to have_field('作品名読み', with: receipt.title_kana)
    end

    it '工作員を新規登録して再検索すると-1の値が設定される' do
      receipt = create(:receipt, :non_ordered, :without_worker)

      visit "/admin/receipts/#{receipt.id}/edit"

      choose '上記の内容で工作員を新規登録する'
      click_on('再検索')
      expect(page).to have_content('申請内容確認')
      expect(page).to have_content(receipt.worker_name)
      expect(page).to have_content('-1')
    end

    it '再検索後、登録まで実行すると登録され申請内容詳細が表示される' do
      receipt = create(:receipt, :non_ordered, :without_worker)

      visit "/admin/receipts/#{receipt.id}/edit"

      choose '上記の内容で工作員を新規登録する'
      click_on('再検索')
      click_on('登録する')
      expect(page).to have_content('申請内容詳細')
      expect(page).to have_content(receipt.worker_name)

      # worker_idが設定される
      receipt.reload
      expect(receipt.worker_id).to eq(Work.last.workers.last.id)
    end
  end

  describe '人物と工作員両方の新規登録の申請受理' do
    before do
      Capybara.current_session.driver.browser.manage.window.resize_to(1280, 4000)
    end

    it '工作員名と著者データはフォームになる' do
      receipt = create(:receipt, :non_ordered, :without_worker, :without_person)

      visit "/admin/receipts/#{receipt.id}/edit"
      expect(page).to have_content('申請内容確認')
      expect(page).to have_field('作品名', with: receipt.title)
      expect(page).to have_field('作品名読み', with: receipt.title_kana)
      expect(page).to have_field('作品名', with: receipt.title)
      expect(page).to have_field('作品名読み', with: receipt.title_kana)
    end

    it '工作員を新規登録して再検索すると-1の値が設定される' do
      receipt = create(:receipt, :non_ordered, :without_worker, :without_person)

      visit "/admin/receipts/#{receipt.id}/edit"

      choose '上記の内容で工作員を新規登録する'
      within('#worker-selector') do
        click_on('再検索')
      end
      expect(page).to have_content('申請内容確認')
      expect(page).to have_content(receipt.worker_name)
      expect(page).to have_content('-1')
    end

    it '工作員と人物の再検索後、登録まで実行すると登録され申請内容詳細が表示される' do
      receipt = create(:receipt, :non_ordered, :without_worker, :without_person)

      visit "/admin/receipts/#{receipt.id}/edit"

      choose '上記の内容で工作員を新規登録する'
      within('#worker-selector') do
        click_on('再検索')
      end
      click_on('登録する')

      choose '上記の内容で人物を新規登録する'
      within('#person-selector') do
        click_on('再検索')
      end

      click_on('登録する')

      expect(page).to have_content('申請内容詳細')
      expect(page).to have_content(receipt.worker_name)

      # worker_idとperson_idが設定される
      receipt.reload
      expect(receipt.worker_id).to eq(Work.last.workers.last.id)
      expect(receipt.person_id).to eq(Work.last.people.last.id)
    end
  end

  describe '警告の表示' do
    context 'すでに登録されている作品とかぶる作品の申請' do
      it '警告が表示される' do
        person = create(:person)
        work = create(:work)
        _work_person = create(:work_person, person:, work:, role_id: 1)
        receipt = create(:receipt,
                         :non_ordered,
                         person_id: person.id,
                         title: work.title,
                         kana_type_id: work.kana_type_id)

        visit "/admin/receipts/#{receipt.id}/edit"
        expect(page).to have_content('申請内容確認')
        expect(page).to have_content('同じ作家による、同一タイトル、同一仮名遣いの作品が、すでに登録されています。')
      end

      it '警告が表示されてもそのまま申請できる' do
        person = create(:person)
        work = create(:work)
        _work_person = create(:work_person, person:, work:, role_id: 1)
        receipt = create(:receipt,
                         :non_ordered,
                         person_id: person.id,
                         title: work.title,
                         kana_type_id: work.kana_type_id)

        visit "/admin/receipts/#{receipt.id}/edit"

        click_on('登録する')

        expect(page).to have_content('申請内容詳細')
        expect(page).to have_content(receipt.title)
        expect(page).to have_content(receipt.worker_name)

        # worker_idとperson_idが設定される
        receipt.reload
        expect(receipt.worker_id).to eq(Work.last.workers.last.id)
        expect(receipt.person_id).to eq(Work.last.people.last.id)
      end
    end

    context 'すでに登録されている作品とかぶる作品の申請(あとから作者が指定される)' do
      before do
        Capybara.current_session.driver.browser.manage.window.resize_to(1280, 4000)
      end

      it '作者を指定しないときは警告は表示されない' do
        person = create(:person, copyright_flag: false)
        work = create(:work)
        _work_person = create(:work_person, person:, work:, role_id: 1)
        receipt = create(:receipt,
                         :non_ordered,
                         :without_person,
                         copyright_flag: false,
                         last_name: person.last_name,
                         first_name: person.first_name,
                         title: work.title,
                         kana_type_id: work.kana_type_id)

        visit "/admin/receipts/#{receipt.id}/edit"
        expect(page).to have_content('申請内容確認')
        expect(page).to have_no_content('同じ作家による、同一タイトル、同一仮名遣いの作品が、すでに登録されています。')
      end

      it '作者の名前が選択できるはずなので、選択して再検索すると警告が出る' do
        person = create(:person, copyright_flag: false)
        work = create(:work)
        _work_person = create(:work_person, person:, work:, role_id: 1)
        receipt = create(:receipt,
                         :non_ordered,
                         :without_person,
                         copyright_flag: false,
                         last_name: person.last_name,
                         first_name: person.first_name,
                         title: work.title,
                         kana_type_id: work.kana_type_id)

        visit "/admin/receipts/#{receipt.id}/edit"

        choose person.name
        click_on('再検索')
        expect(page).to have_content('同じ作家による、同一タイトル、同一仮名遣いの作品が、すでに登録されています。')
      end

      it '再検索後警告が出ても登録できる' do
        person = create(:person, copyright_flag: false)
        work = create(:work)
        _work_person = create(:work_person, person:, work:, role_id: 1)
        receipt = create(:receipt,
                         :non_ordered,
                         :without_person,
                         copyright_flag: false,
                         last_name: person.last_name,
                         first_name: person.first_name,
                         title: work.title,
                         kana_type_id: work.kana_type_id)

        visit "/admin/receipts/#{receipt.id}/edit"

        choose person.name
        click_on('再検索')
        click_on('登録する')

        expect(page).to have_content('申請内容詳細')
        expect(page).to have_content(receipt.title)
        expect(page).to have_content(receipt.worker_name)

        # person_idが設定される
        receipt.reload
        expect(receipt.person_id).to eq(Work.last.people.last.id)
      end
    end

    context '著作権フラグが著者と作品で異なる場合' do
      it '警告が表示される' do
        person = create(:person, copyright_flag: false)
        receipt = create(:receipt,
                         :non_ordered,
                         person_id: person.id,
                         copyright_flag: true)

        visit "/admin/receipts/#{receipt.id}/edit"
        expect(page).to have_content('申請内容確認')
        expect(page).to have_content('著作権フラグの「あり」「なし」が合致していません。')
      end

      it '警告が表示されてもそのまま申請できる' do
        person = create(:person, copyright_flag: false)
        receipt = create(:receipt,
                         :non_ordered,
                         person_id: person.id,
                         copyright_flag: true)

        visit "/admin/receipts/#{receipt.id}/edit"

        click_on('登録する')

        expect(page).to have_content('申請内容詳細')
        expect(page).to have_content(receipt.title)
        expect(page).to have_content(receipt.worker_name)

        # worker_idとperson_idが設定される
        receipt.reload
        expect(receipt.person_id).to eq(Work.last.people.last.id)
      end
    end

    context '問題ない場合' do
      it '警告は表示されない' do
        person = create(:person, copyright_flag: true)
        receipt = create(:receipt,
                         :non_ordered,
                         person_id: person.id,
                         copyright_flag: true)

        visit "/admin/receipts/#{receipt.id}/edit"
        expect(page).to have_content('申請内容確認')
        expect(page).to have_no_content('著作権フラグの「あり」「なし」が合致していません。')
        expect(page).to have_no_content('同じ作家による、同一タイトル、同一仮名遣いの作品が、すでに登録されています。')
      end
    end
  end
end
