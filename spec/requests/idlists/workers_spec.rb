# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Idlists::Workers' do
  describe 'GET /idlists/workers/' do
    it 'returns http success' do
      get '/idlists/workers/'
      expect(response).to have_http_status(:success)
    end
  end
end
