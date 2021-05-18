# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::ExecCommands', type: :request do
  let(:user) { create(:user) }

  describe 'GET /' do
    before { sign_in(user) }

    it 'returns http success' do
      get '/admin/exec_commands'
      expect(response).to have_http_status(:success)
    end
  end
end
