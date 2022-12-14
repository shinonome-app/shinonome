# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Idlists' do
  describe 'GET /idlists/' do
    it 'returns http success' do
      get '/idlists/'
      expect(response).to have_http_status(:success)
    end
  end
end
