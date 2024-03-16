# frozen_string_literal: true

require 'rails_helper'

describe ProofreadsController do
  describe '#index' do
    it 'トップページから入力受付システムに遷移する' do
      visit '/'
      click_link('校正受付システム', href: '/proofreads') # rubocop:disable Capybara/ClickLinkOrButtonStyle

      expect(page).to have_content('校正受付システム：作業中作家インデックス')
    end
  end

  describe '#new' do
    let(:person) { create(:person, last_name: '芥川', first_name: '竜之介', last_name_kana: 'あくたがわ', first_name_kana: 'りゅうのすけ', sortkey: 'あくたがわ', sortkey2: 'りゅうのすけ') }
    let(:work1) { create(:work, :teihon, work_status_id: 5, title: '作品その1') }
    let(:work2) { create(:work, :teihon, work_status_id: 5, title: '作品その2') }
    let(:worker) do
      create(:worker, name: '青空太郎', name_kana: 'あおぞらたろう', sortkey: 'あおぞらたろう') do |worker|
        worker.worker_secret.update!(email: 'taro@example.com', url: 'https://example.com/taro')
      end
    end

    before do
      create(:work_person, work: work1, person:)
      create(:work_person, work: work2, person:)
    end

    context '入力フォームで工作員IDを入力する場合' do
      it '確認画面では名前のみ表示し、メールアドレス等は表示しない' do
        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員ID', with: worker.id

        click_on('確認')

        expect(page).to have_content('校正受付システム：記入事項の確認')

        # 名前は表示する
        expect(page).to have_content('工作員名（必須） 青空太郎')

        # メールアドレスやURLは非公開なので表示しない
        expect(page).to have_no_content('taro@example.com')
        expect(page).to have_no_content('https://example.com/taro')
      end

      it '要コピーを選んで送付先を入力しないとエラーになる' do
        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員ID', with: worker.id
        check('要コピー')

        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')
        expect(page).to have_content('1件のエラーが見つかりました')
        expect(page).to have_content('送付先を入力してくだい')
      end

      it '確認画面から登録に進むと登録してメールを飛ばす' do
        allow(UserMailer).to receive(:register_proofread).once.and_call_original

        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員ID', with: worker.id

        click_on('確認')

        expect(page).to have_content('校正受付システム：記入事項の確認')
        click_on('登録')

        expect(page).to have_content('校正受付システム：受付完了')
        expect(UserMailer).to have_received(:register_proofread)

        proofread = Proofread.last
        expect(proofread.worker_id).to eq worker.id
        expect(proofread.worker_name).to eq worker.name
        expect(proofread.worker_kana).to eq worker.name_kana
        expect(proofread.email).to eq worker.worker_secret.email
        expect(proofread.need_print?).to be false
        expect(proofread.need_copy?).to be false
        expect(proofread.ordered?).to be false
        expect(proofread.assigned?).to be false
      end

      it 'もろもろ入力して確認画面から登録に進むとそれらが登録される' do
        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員ID', with: worker.id
        fill_in '送付先', with: "送付先A\n送付先B\n送付先C\n"
        check('要コピー')
        check('要プリントアウト')

        click_on('確認')

        expect(page).to have_content('校正受付システム：記入事項の確認')
        click_on('登録')

        expect(page).to have_content('校正受付システム：受付完了')
        proofread = Proofread.last
        expect(proofread.worker_id).to eq worker.id
        expect(proofread.worker_name).to eq worker.name
        expect(proofread.worker_kana).to eq worker.name_kana
        expect(proofread.email).to eq worker.worker_secret.email
        expect(proofread.address).to eq "送付先A\r\n送付先B\r\n送付先C\r\n"
        expect(proofread.need_print?).to be true
        expect(proofread.need_copy?).to be true
        expect(proofread.ordered?).to be false
        expect(proofread.assigned?).to be false
      end
    end

    context '入力フォームで工作員の名前を入力する場合' do
      it '名前のみではエラーになる' do
        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員読み', with: 'こうさくいんいち'
        fill_in '工作員名', with: '工作員1'

        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')
        expect(page).to have_content('1件のエラーが見つかりました')
        expect(page).to have_content('e-mailを入力してください')

        # 名前はフォームに残っている
        expect(page).to have_content('工作員名（必須） 青空太郎')
      end

      it '全部入力すると確認画面に進む' do
        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員読み', with: 'こうさくいんいち'
        fill_in '工作員名', with: '工作員1'
        fill_in 'e-mail', with: 'user1@example.com'
        fill_in 'ホームページ', with: 'https://example.com/user1'

        click_on('確認')

        expect(page).to have_content('校正受付システム：記入事項の確認')

        # 名前に加えて、メールアドレスやURLも表示する
        expect(page).to have_content('工作員1')
        expect(page).to have_content('連絡事項1')
        expect(page).to have_content('user1@example.com')
        expect(page).to have_content('https://example.com/user1')
      end

      it '確認画面から登録に進むと登録してメールを飛ばす' do
        allow(UserMailer).to receive(:register_proofread).once.and_call_original

        visit "/proofreads/people/#{person.id}"

        find('form[action="/proofreads/new"]').first('input[type="checkbox"]').set(true)
        click_on('確認')

        expect(page).to have_content('校正受付システム：必要事項の記入')

        fill_in '連絡事項', with: '連絡事項1'
        fill_in '工作員読み', with: 'こうさくいんいち'
        fill_in '工作員名', with: '工作員1'
        fill_in 'e-mail', with: 'user1@example.com'
        fill_in 'ホームページ', with: 'https://example.com/user1'

        click_on('確認')

        expect(page).to have_content('校正受付システム：記入事項の確認')
        click_on('登録')

        expect(page).to have_content('校正受付システム：受付完了')
        expect(UserMailer).to have_received(:register_proofread)

        proofread = Proofread.last
        expect(proofread.worker_id).to be_nil
        expect(proofread.worker_name).to eq '工作員1'
        expect(proofread.worker_kana).to eq 'こうさくいんいち'
        expect(proofread.email).to eq 'user1@example.com'
        expect(proofread.need_print?).to be false
        expect(proofread.need_copy?).to be false
        expect(proofread.ordered?).to be false
        expect(proofread.assigned?).to be false
      end
    end
  end
end
