# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::TextSearches', type: :request do
  before { sign_in(user) }
  let(:user) { create(:user) }

  describe 'GET /admin/books/text_searches' do
    it 'returns http success' do
      get '/admin/books/text_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
