# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::UnknownCreatorSearches', type: :request do
  before { sign_in(user) }
  let(:user) { create(:user) }

  describe 'GET /admin/books/unknown_creator_searches' do
    it 'returns http success' do
      get '/admin/books/unknown_creator_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
