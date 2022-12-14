# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Works::UnknownCreatorSearches' do
  before { sign_in(user) }

  let(:user) { create(:user) }

  describe 'GET /admin/works/unknown_creator_searches' do
    it 'returns http success' do
      get '/admin/works/unknown_creator_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
