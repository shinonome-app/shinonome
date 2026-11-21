# frozen_string_literal: true

# ログインしていなくても使える create（管理画面のログイン・パスワードリセット、公開の入力申請・校正申請）を
# IP ごとに回数制限する。
# - ログイン：パスワードの総当たり対策
# - パスワードリセット・入力申請・校正申請：メールを送るので、任意のアドレスへの大量送信の踏み台にされないようにする
#
# 確認画面（*::PreviewsController）と、確認画面からの「戻る」（*::EditsController）は、
# 保存もメール送信もしないので対象にしない。
# 確認と修正をくり返す正規の利用者が、先に制限にかかってしまうため。
#
# カウンタは Rails.cache に保存される。
module RateLimitedCreate
  extend ActiveSupport::Concern

  included do
    rate_limit to: 10, within: 10.minutes, only: :create,
               with: -> { render TooManyRequestsComponent.new, layout: 'application', status: :too_many_requests }
  end
end
