# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TopPageContents::PreviewsController do
  describe 'POST /admin/top_page_content/preview' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'renders a preview' do
      post '/admin/top_page_content/preview', params: { editable_content: { value: '<div>preview</div>' } }

      expect(response).to have_http_status(:success)
      expect(response.body).to include('preview')
    end
  end
end
