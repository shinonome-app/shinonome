# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idlists::WorkersController do
  describe 'GET /idlist/workers' do
    it 'returns http success' do
      get idlists_workers_path
      expect(response).to have_http_status(:success)
    end
  end
end
