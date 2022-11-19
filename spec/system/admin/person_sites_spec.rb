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

  describe '#create' do
    it '人物詳細で関連づけをクリックすると関連づけられる' do
      visit "/admin/people/#{person.id}/person_sites/text_searches"

      expect(page).to have_content('関連サイト検索結果一覧')
      expect(page).to have_content(/#{site.id}.*#{site.name}.*#{site.url}/)
      expect(page).to have_content(/#{site2.id}.*#{site2.name}.*#{site2.url}/)

      page.find("#person-site-#{site.id}").click_button('関連づける')

      expect(page).to have_content('関連づけました.')
      expect(page).to have_content('人物詳細')

      expect(page).to have_content(/関連サイト名.*#{site.name}/)
    end

    it 'すでに関連づけされていた場合はエラーになる' do
      visit "/admin/people/#{person.id}/person_sites/text_searches"

      PersonSite.create!(person_id: person.id, site_id: site.id)

      page.find("#person-site-#{site.id}").click_button('関連づける')

      expect(page).to have_content('人物IDがすでに関連付けられています')
      expect(page).to have_content('人物詳細')
    end
  end

  describe '#delete' do
    before do
      create(:person_site, person: person, site: site)
    end

    it '人物詳細で削除をクリックすると削除される' do
      visit "/admin/people/#{person.id}"

      expect(page).to have_content('人物詳細')
      expect(page).to have_content(/関連サイト名.*#{site.name}/)

      page.find('h3', text: '関連サイトデータ').sibling('div').click_button('削除')
      expect do
        expect(page.accept_confirm).to eq '本当に削除しますか?'
        expect(page).to have_content '関連サイトの関連づけを削除しました'
      end.to change(PersonSite, :count).by(-1)
    end
  end
end
