# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::People::PersonIndexSearchesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get admin_people_person_index_searches_url(person: 'あ')
      expect(response).to be_successful
    end

    it '人物名の読み(sortkey)順で並ぶ' do
      # 同じ頭文字「あ」で読みの異なる人物を、敢えて読み順と逆の作成順で用意する
      third  = create(:person, last_name: 'ZZCCC', sortkey: 'あさ', sortkey2: '')
      first  = create(:person, last_name: 'ZZAAA', sortkey: 'あい', sortkey2: '')
      second = create(:person, last_name: 'ZZBBB', sortkey: 'あか', sortkey2: '')

      get admin_people_person_index_searches_url(person: 'あ')

      expect(response).to be_successful
      body = response.body
      expect(body.index(first.last_name)).to be < body.index(second.last_name)
      expect(body.index(second.last_name)).to be < body.index(third.last_name)
    end

    it 'sortkeyが同じ場合は名の読み(sortkey2)で並ぶ' do
      later   = create(:person, last_name: 'ZZYYY', sortkey: 'あおき', sortkey2: 'はじめ')
      earlier = create(:person, last_name: 'ZZXXX', sortkey: 'あおき', sortkey2: 'あきら')

      get admin_people_person_index_searches_url(person: 'あ')

      expect(response).to be_successful
      body = response.body
      expect(body.index(earlier.last_name)).to be < body.index(later.last_name)
    end

    it '選択した頭文字に一致する人物のみ表示する' do
      target = create(:person, last_name: 'ZZHIT', sortkey: 'あいうえ', sortkey2: '')
      other  = create(:person, last_name: 'ZZMISS', sortkey: 'かきくけ', sortkey2: '')

      get admin_people_person_index_searches_url(person: 'あ')

      expect(response.body).to include(target.last_name)
      expect(response.body).not_to include(other.last_name)
    end

    it '1ページあたり50件に制限される' do
      create_list(:person, 51, sortkey: 'あいうえお', sortkey2: '') # rubocop:disable FactoryBot/ExcessiveCreateList

      get admin_people_person_index_searches_url(person: 'あ')

      expect(response).to be_successful
      # 各人物は /admin/people/{id} へリンクされる。表示行数を数えて50件に制限されることを確認する
      shown = response.body.scan(%r{href="/admin/people/\d+"}).size
      expect(shown).to eq(50)
    end

    it 'all指定時は件数制限なしで全件表示する' do
      create_list(:person, 51, sortkey: 'あいうえお', sortkey2: '') # rubocop:disable FactoryBot/ExcessiveCreateList

      get admin_people_person_index_searches_url(person: 'あ', all: 1)

      expect(response).to be_successful
      shown = response.body.scan(%r{href="/admin/people/\d+"}).size
      expect(shown).to eq(51)
    end
  end
end
