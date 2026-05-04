# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::People::PreviewsController do
  describe 'GET /admin/people/previews/:id' do
    let(:person) { create(:person, copyright_flag: false) }
    let(:user) { create(:user) }

    before { sign_in(user) }

    it 'renders the person page preview via natsuzora' do
      get "/admin/people/previews/#{person.id}"

      expect(response).to have_http_status(:success)
      expect(response.body).to include('<html')
    end
  end
end
