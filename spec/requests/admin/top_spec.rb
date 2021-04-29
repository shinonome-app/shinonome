require 'rails_helper'

RSpec.describe "Admin::Tops", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/top/index"
      expect(response).to have_http_status(:success)
    end
  end

end
