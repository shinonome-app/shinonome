# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Works::WorkerAssigns', type: :request do
  before { sign_in(user) }

  let(:user) { create(:user, email: 'user2@example.jp', username: 'user2') }

  describe 'GET /admin/works/:work_id/worker_assigns/nwe' do
    let!(:work) { create(:work) }

    it 'returns http success' do
      get "/admin/works/#{work.id}/worker_assigns/new"
      expect(response).to have_http_status(:success)
    end
  end
end
