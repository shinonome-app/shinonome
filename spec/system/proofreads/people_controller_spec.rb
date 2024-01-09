# frozen_string_literal: true

require 'rails_helper'

describe Proofreads::PeopleController do
  let(:person) { create(:person, last_name: '青空', first_name: '太郎', last_name_kana: 'あおぞら', first_name_kana: 'たろう', sortkey: 'あおぞら', sortkey2: 'たろう') }
  let(:work1) { create(:work, :teihon, work_status_id: 5, title: '作品その1') }
  let(:work2) { create(:work, :teihon, work_status_id: 5, title: '作品その2') }

  before do
    create(:work_person, work: work1, person:)
    create(:work_person, work: work2, person:)
  end

  describe '#index' do
    it '作家別の「あ」をクリックすると校正待ち作家一覧が表示される' do
      visit '/proofreads'

      click_link('あ', href: '/proofreads/people?people=a') # rubocop:disable Capybara/ClickLinkOrButtonStyle

      expect(page).to have_content('校正受付システム　作家リスト：あ')
      expect(page).to have_content('青空 太郎')
    end
  end

  describe '#show' do
    it '作家名をクリックすると校正待ちタイトルが表示され、チェックを入れるとそのタイトルの入力フォームに飛ぶ' do
      visit '/proofreads/people?people=a'

      click_on('青空 太郎')

      expect(page).to have_content('校正受付システム:青空 太郎')
      expect(page).to have_content('作品その1')
      expect(page).to have_content('作品その2')

      find('form[action="/proofreads/new"]').first('input[type="checkbox"]').click

      click_on('確認')

      expect(page).to have_content('校正受付システム：必要事項の記入')
      expect(page).to have_content('作品その1')
      expect(page).to have_no_content('作品その2')
    end

    it '作家名をクリックすると校正待ちタイトルが表示され、全てチェックを入れると入力フォームに飛ぶ' do
      visit '/proofreads/people?people=a'

      click_on('青空 太郎')

      expect(page).to have_content('校正受付システム:青空 太郎')
      expect(page).to have_content('作品その1')
      expect(page).to have_content('作品その2')

      find('form[action="/proofreads/new"]').all('input[type="checkbox"]').each { |input| input.click } # rubocop:disable Rails/FindEach

      click_on('確認')

      expect(page).to have_content('校正受付システム：必要事項の記入')
      expect(page).to have_content(work1.title)
      expect(page).to have_content(work2.title)
    end
  end
end
