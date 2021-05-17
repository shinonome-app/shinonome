# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::ExecCommands', type: :request do
  describe 'GET /index' do
    it 'returns http success' do
      get '/admin/exec_commands/index'
      expect(response).to have_http_status(:success)
    end
  end
end
