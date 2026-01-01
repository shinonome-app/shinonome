# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TopPageContentsController do
  describe 'GET /admin/top_page_content/edit' do
    context 'without sign in' do
      it 'redirects to the login page' do
        get '/admin/top_page_content/edit'
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'with sign in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'returns http success' do
        get '/admin/top_page_content/edit'
        expect(response).to have_http_status(:success)
        expect(response.body).to include('トップページHTML編集')
      end
    end
  end

  describe 'POST /admin/top_page_content' do
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'creates a draft' do
      expect do
        post '/admin/top_page_content', params: { editable_content: { value: '<p>draft</p>' } }
      end.to change(EditableContent, :count).by(1)

      draft = EditableContent.last
      expect(draft.status).to eq('draft')
      expect(draft.value).to eq('<p>draft</p>')
    end
  end
end
