# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Receipts::Thanks' do
  describe 'GET /receipts/thanks/' do
    it 'returns http success' do
      get '/receipts/thanks/'
      expect(response).to have_http_status(:success)
    end
  end
end
