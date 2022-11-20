# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AsideComponent, type: :component do
  it 'HTMLを表示' do
    fragment = render_inline(Admin::AsideComponent.new).to_html
    expect(fragment).to have_link('作品新規登録', href: '/admin/works/new')
    expect(fragment).to have_link('作品検索', href: '/admin/works')
    expect(fragment).to have_link('WEB入力受付処理', href: '/admin/receipts')
    expect(fragment).to have_link('WEB校正受付処理', href: '/admin/proofreads')
    expect(fragment).to have_link('そらもよう', href: '/admin/news_entries')
  end
end
