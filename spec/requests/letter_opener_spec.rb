# frozen_string_literal: true

require 'rails_helper'

# letter_opener_web は送信メール（パスワードリセットURL等）を認証なしで閲覧できるため、
# 開発環境以外ではマウントしない
RSpec.describe 'LetterOpenerWeb' do
  it 'is not routed outside development' do
    get '/letter_opener'
    expect(response).to have_http_status(:not_found)
  end
end
