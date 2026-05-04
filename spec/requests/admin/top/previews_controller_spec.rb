# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Top::PreviewsController do
  describe 'GET /admin/top/previews' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'renders the top page preview via natsuzora' do
      get '/admin/top/previews'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<html')
    end
  end
end
