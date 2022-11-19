require 'rails_helper'

describe 'Admin::PersonSitesController' do
  let!(:user) { create(:user) }
  let!(:person) { create(:person) }
  let!(:site) { create(:site) }
  let!(:site2) { create(:site) }
  before { sign_in(user) }

  describe '#new' do
    it '人物詳細で関連づけをクリックすると表示される' do
      visit "/admin/people/#{person.id}"

      expect(page).to have_content('人物詳細')

      click_link('関連づけ', href: "/admin/people/#{person.id}/person_sites/new")
      expect(page).to have_content('関連サイト関連づけ登録')

      expect(page).to have_content("対象人物: #{person.name}")
    end
  end

  describe 'text_searches' do
    it '人物詳細で関連づけをクリックすると表示される' do
      visit "/admin/people/#{person.id}/person_sites/text_searches"

      expect(page).to have_content('関連サイト検索結果一覧')
      expect(page).to have_content(/#{site.id}.*#{site.name}.*#{site.url}/)
      expect(page).to have_content(/#{site2.id}.*#{site2.name}.*#{site2.url}/)

      page.find("#person-site-#{site.id}").click_button('関連づける')

      expect(page).to have_content("関連づけました.")
      expect(page).to have_content("人物詳細")

      expect(page).to have_content(/関連サイト名.*#{site.name}/)
    end
  end
end
