# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Works::CreatorIndexSearches' do
  before { sign_in(user) }

  let(:user) { create(:user) }

  describe 'GET /admin/works/creator_index_searches' do
    it 'returns http success' do
      get '/admin/works/creator_index_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
