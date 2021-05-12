# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Books::WorkerAssigns', type: :request do
  before { sign_in(user) }

  let(:user) { create(:user, email: 'user2@example.jp', username: 'user2') }

  describe 'GET /admin/books/:book_id/worker_assigns/nwe' do
    let!(:book) { create(:book) }

    it 'returns http success' do
      get "/admin/books/#{book.id}/worker_assigns/new"
      expect(response).to have_http_status(:success)
    end
  end
end
