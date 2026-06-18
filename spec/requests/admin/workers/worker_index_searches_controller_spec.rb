# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Workers::WorkerIndexSearchesController do
  let(:user) { create(:user) }

  before { sign_in(user) }

  describe 'GET /index' do
    it 'renders a successful response' do
      get admin_workers_worker_index_searches_url(worker: 'あ')
      expect(response).to be_successful
    end

    it '1ページあたり50件に制限される' do
      create_list(:worker, 51, sortkey: 'あいうえお') # rubocop:disable FactoryBot/ExcessiveCreateList

      get admin_workers_worker_index_searches_url(worker: 'あ')

      expect(response).to be_successful
      # 各耕作員は /admin/workers/{id} へリンクされる
      shown = response.body.scan(%r{href="/admin/workers/\d+"}).size
      expect(shown).to eq(50)
    end

    it 'all指定時は件数制限なしで全件表示する' do
      create_list(:worker, 51, sortkey: 'あいうえお') # rubocop:disable FactoryBot/ExcessiveCreateList

      get admin_workers_worker_index_searches_url(worker: 'あ', all: 1)

      expect(response).to be_successful
      shown = response.body.scan(%r{href="/admin/workers/\d+"}).size
      expect(shown).to eq(51)
    end
  end
end
