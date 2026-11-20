# frozen_string_literal: true

require 'rails_helper'

# sandbox を付けたプレビュー（opaque origin）からもフォントを読めること
RSpec.describe 'Font CORS headers' do
  it 'adds Access-Control-Allow-Origin to font responses' do
    get ActionController::Base.helpers.asset_path('Inter-roman.latin.var.woff2')

    expect(response).to have_http_status(:ok)
    expect(response.headers['Access-Control-Allow-Origin']).to eq('*')
  end

  it 'does not add it to other responses' do
    get ActionController::Base.helpers.asset_path('inter-font.css')

    expect(response).to have_http_status(:ok)
    expect(response.headers['Access-Control-Allow-Origin']).to be_nil
  end
end
