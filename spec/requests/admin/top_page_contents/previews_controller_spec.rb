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

    it 'renders a natsuzora fragment with context variables' do
      post '/admin/top_page_content/preview',
           params: { editable_content: { value: '<p>total: {[ works_count ]}</p>' } }

      expect(response).to have_http_status(:success)
      expect(response.body).to include("total: #{Work.published.count}")
    end

    it 'returns unprocessable_entity for invalid natsuzora syntax' do
      post '/admin/top_page_content/preview', params: { editable_content: { value: '{[#if' } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include('テンプレートエラー')
    end

    it 'renders the default body when value is empty' do
      post '/admin/top_page_content/preview', params: { editable_content: { value: '' } }

      expect(response).to have_http_status(:success)
      expect(response.body).to include('メインエリア')
    end
  end
end
