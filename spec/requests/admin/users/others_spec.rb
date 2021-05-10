# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users::Others', type: :request do

  let(:valid_attributes) do
    {
      username: 'user3',
      email: 'user3@example.com',
      password: 'pass123#'
    }
  end

  let(:invalid_attributes) do
    {
      username: nil,
      email: 'user3@example.com',
      password: 'pass123#'
    }
  end

  let(:user) { create(:user) }
  let(:user2) { create(:user, email: 'user2@xample.com', username: 'user2') }

  before { sign_in(user) }

  describe 'GET /' do
    it 'returns http success' do
      get '/admin/users/others'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE /destroy' do
    before { sign_in user }

    it 'destroys the requested user' do
      user = User.create! valid_attributes
      expect do
        delete admin_users_other_url(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the user list' do
      user = User.create! valid_attributes
      delete admin_users_other_url(user)
      expect(response).to redirect_to(admin_users_others_url)
    end
  end
end
