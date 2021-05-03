# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/users/index'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /delete' do
    it 'returns http success' do
      get '/admin/users/delete'
      expect(response).to have_http_status(:success)
    end
  end
end
