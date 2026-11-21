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

    it 'sandboxes the preview with CSP' do
      get '/admin/top/previews'
      expect(response.headers['Content-Security-Policy']).to start_with('sandbox allow-scripts')
    end

    it 'renders the published editable content' do
      EditableContent.delete_all
      create(:editable_content, area_name: 'top', key: 'main', status: 'published',
                                value: '<p>published-fragment</p>')

      get '/admin/top/previews'

      expect(response).to have_http_status(:success)
      expect(response.body).to include('published-fragment')
    end
  end
end
