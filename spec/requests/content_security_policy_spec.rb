# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content Security Policy' do
  let(:user) { create(:user) }

  it 'sends the policy as report-only on admin pages' do
    sign_in(user)
    get '/admin'

    policy = response.headers['Content-Security-Policy-Report-Only']
    expect(policy).to include("default-src 'self'")
    expect(policy).to include("object-src 'none'")
    expect(policy).to include("frame-ancestors 'none'")
    expect(response.headers['Content-Security-Policy']).to be_nil
  end

  it 'adds the nonce to the importmap inline script' do
    sign_in(user)
    get '/admin'

    nonce = response.headers['Content-Security-Policy-Report-Only'][/'nonce-([^']+)'/, 1]
    expect(nonce).to be_present
    expect(response.body).to include(%(<script type="importmap" data-turbo-track="reload" nonce="#{nonce}">))
  end

  it 'sends the policy on public pages' do
    get new_receipt_path

    expect(response.headers['Content-Security-Policy-Report-Only']).to include("default-src 'self'")
  end

  it 'keeps only the sandbox policy on previews' do
    sign_in(user)
    get '/admin/top/previews'

    expect(response.headers['Content-Security-Policy']).to start_with('sandbox')
    expect(response.headers['Content-Security-Policy-Report-Only']).to be_nil
  end
end
