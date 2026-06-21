# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TopPageContents::TailwindGuidesController do
  describe 'GET /admin/top_page_content/tailwind_guide' do
    context 'without sign in' do
      it 'redirects to the login page' do
        get '/admin/top_page_content/tailwind_guide'
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'with sign in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'returns http success' do
        get '/admin/top_page_content/tailwind_guide'
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Tailwind使い方ガイド')
      end
    end
  end
end
