# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Works::PreviewsController do
  describe 'GET /show' do
    let(:work) { create(:work, :with_person) }
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'returns http success' do
      get "/admin/works/previews/#{work.id}"
      expect(response).to have_http_status(:success)
    end

    it 'sandboxes the preview with CSP' do
      get "/admin/works/previews/#{work.id}"
      expect(response.headers['Content-Security-Policy']).to start_with('sandbox allow-scripts')
    end
  end
end
