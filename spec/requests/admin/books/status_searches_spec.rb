# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::StatusSearches', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/books/status_searches/index'
      expect(response).to have_http_status(:success)
    end
  end
end
