# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Works::TextSearchesController do
  before { sign_in(user) }

  let(:user) { create(:user) }

  describe 'GET /admin/works/text_searches' do
    it 'returns http success' do
      get '/admin/works/text_searches'
      expect(response).to have_http_status(:success)
    end
  end
end
