# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::BookIndexSearches', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/books/book_index_searches/index'
      expect(response).to have_http_status(:success)
    end
  end
end
