# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Idlists::PeopleController do
  describe 'GET /idlist/people' do
    it 'returns http success' do
      get idlists_people_path
      expect(response).to have_http_status(:success)
    end
  end
end
