# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::TextSearches', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/books/text_searches/index'
      expect(response).to have_http_status(:success)
    end
  end
end
