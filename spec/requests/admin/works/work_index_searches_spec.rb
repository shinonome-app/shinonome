# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Works::WorkIndexSearches' do
  before { sign_in(user) }

  let(:user) { create(:user) }

  describe 'GET /admin/works/work_index_searchers' do
    it 'returns http success' do
      get '/admin/works/work_index_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
