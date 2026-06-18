# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdlistsController do
  describe 'GET /idlist' do
    it 'returns http success' do
      get idlists_path
      expect(response).to have_http_status(:success)
    end
  end
end
