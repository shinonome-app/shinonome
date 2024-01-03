# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Works::Previews' do
  describe 'GET /show' do
    let(:work) { create(:work, :with_person) }
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'returns http success' do
      get "/admin/works/previews/#{work.id}"
      expect(response).to have_http_status(:success)
    end
  end
end
