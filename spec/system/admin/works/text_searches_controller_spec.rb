# frozen_string_literal: true

require 'rails_helper'

describe Admin::Works::TextSearchesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe '#index' do
    it '作品名で絞り込みされる' do
      create(:work, title: '蜘蛛の糸')
      create(:work, title: '作品その2')

      visit '/admin/works'

      fill_in 'title', with: '蛛の'

      page.find('h2', text: '作品テキスト検索').sibling('form[action="/admin/works/text_searches"]').click_on('検索')

      expect(page).to have_content('作品検索結果一覧')
      expect(page).to have_content('蜘蛛の糸')
      expect(page).to have_no_content('作品その2')
    end

    it '「で始まる」を使うと作品名の先頭で絞り込みされる' do
      create(:work, title: '蜘蛛の糸')
      create(:work, title: '黒後家蜘蛛の会')

      visit '/admin/works'

      fill_in 'title', with: '蜘蛛'
      select 'で始まる', from: 'text_selector_title'

      page.find('h2', text: '作品テキスト検索').sibling('form[action="/admin/works/text_searches"]').click_on('検索')

      expect(page).to have_content('作品検索結果一覧')
      expect(page).to have_content('蜘蛛の糸')
      expect(page).to have_no_content('黒後家蜘蛛の会')
    end

    it '「と等しい」を使うと作品名の完全一致で絞り込みされる' do
      create(:work, title: '蜘蛛の糸')
      create(:work, title: '蜘蛛')

      visit '/admin/works'

      fill_in 'title', with: '蜘蛛'
      select 'と等しい', from: 'text_selector_title'

      page.find('h2', text: '作品テキスト検索').sibling('form[action="/admin/works/text_searches"]').click_on('検索')

      expect(page).to have_content('作品検索結果一覧')
      expect(page).to have_content('蜘蛛')
      expect(page).to have_no_content('蜘蛛の糸')
    end
  end
end
