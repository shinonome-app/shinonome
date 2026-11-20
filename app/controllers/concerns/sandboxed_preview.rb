# frozen_string_literal: true

# 公開サイト用の natsuzora テンプレートを管理画面でプレビューするコントローラ用。
#
# プレビューの HTML は、外部の Tailwind CDN のスクリプトや、作品の備考・人物の解説などの
# エスケープしない HTML を含む。管理画面と同じオリジンで描画すると、それらのスクリプトが
# 管理者のセッションで動いてしまうため、CSP の sandbox でページを opaque origin にする。
# - allow-scripts: Tailwind CDN のスクリプトを動かすため
# - allow-forms: トップの検索フォームや図書カードの「えあ草紙」ボタンを送信できるようにするため
#   （opaque origin からの POST には SameSite=Lax のセッション Cookie が付かないので、管理画面は操作できない）
# - allow-popups / allow-popups-to-escape-sandbox: target="_blank" のリンクを開けるようにするため
module SandboxedPreview
  extend ActiveSupport::Concern

  SANDBOX_POLICY = 'sandbox allow-scripts allow-forms allow-popups allow-popups-to-escape-sandbox'

  # プレビュー時のみ Tailwind を CDN で読み込ませ、任意の Tailwind クラスを確実に反映させる。
  PREVIEW_TAILWIND_CDN = '<script src="https://cdn.tailwindcss.com"></script>'

  included do
    before_action :set_sandbox_policy
  end

  private

  def set_sandbox_policy
    response.headers['Content-Security-Policy'] = SANDBOX_POLICY
  end

  def with_preview_styles(html)
    if html.include?('</head>')
      html.sub('</head>', "#{PREVIEW_TAILWIND_CDN}\n</head>")
    else
      "#{PREVIEW_TAILWIND_CDN}\n#{html}"
    end
  end
end
