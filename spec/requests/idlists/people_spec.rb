require 'rails_helper'

RSpec.describe "Idlists::People", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/idlists/people/index"
      expect(response).to have_http_status(:success)
    end
  end

end
