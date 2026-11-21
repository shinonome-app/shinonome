# frozen_string_literal: true

module ApplicationHelper
  def nl2br(str)
    str&.gsub(/\r?\n/, "<br>\n")
  end

  # DB に保存された HTML を安全に出力するヘルパー。図書カードなどと同じ規則（HtmlSanitizer）を使う
  def safe_html(text)
    HtmlSanitizer.new.sanitize(text).html_safe # rubocop:disable Rails/OutputSafety
  end

  # URLが安全かどうかをチェックするヘルパー
  def safe_url?(url)
    return false if url.blank?

    # URLの妥当性をチェック
    uri = URI.parse(url)

    # 許可されたスキームのみ（http, https, mailto）
    allowed_schemes = %w[http https mailto]
    allowed_schemes.include?(uri.scheme&.downcase)
  rescue URI::InvalidURIError
    # 不正なURLの場合はfalseを返す
    false
  end

  # link_to(url, url)形式専用の安全なリンク生成ヘルパー
  def safe_link_url(url, html_options = {})
    return '-' if url.blank?

    if safe_url?(url)
      link_to(url, url, html_options)
    else
      # 危険なURLの場合はリンクではなく文字列として表示
      url
    end
  end

  # for admin pages
  def snm_link(label, href: nil, font_color: 'sidebar', icon: nil, button_style: 'primary', target: nil)
    render(Admin::SnmLinkComponent.new(label:, href:, font_color:, icon:, button_style:, target:))
  end

  def snm_headline(h:, &) # rubocop:disable Naming/MethodParameterName
    render(Admin::SnmHeadlineComponent.new(h:), &)
  end
end
