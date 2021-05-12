# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Tops', type: :request do
  describe 'GET /admin' do
    context 'without sign in' do
      it 'redirects to the login page' do
        get '/admin/'
        expect(response).to redirect_to(new_admin_user_session_path)
      end
    end

    context 'with sign in' do
      let(:user) { create(:user) }

      before { sign_in(user) }

      it 'returns http success' do
        get '/admin/'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
