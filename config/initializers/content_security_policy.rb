# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header
#
# まずは report-only で運用し、ブラウザのコンソールに違反が出ないことを確認してから強制に切り替える。
#
# 公開サイトのプレビュー（SandboxedPreview を include したコントローラ）は、
# 独自に `Content-Security-Policy: sandbox ...` を付けるため、このポリシーは適用されない
# （ActionDispatch::ContentSecurityPolicy::Middleware は CSP ヘッダがすでにあれば何もしない）。
Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.base_uri    :self
    policy.connect_src :self
    policy.font_src    :self, :data
    policy.form_action :self
    policy.frame_ancestors :none
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self
    policy.style_src   :self, :unsafe_inline
  end

  # importmap が出力するインラインスクリプトに nonce を付ける
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]

  # Report violations without enforcing the policy.
  config.content_security_policy_report_only = true
end
