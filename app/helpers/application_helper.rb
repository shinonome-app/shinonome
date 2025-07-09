# frozen_string_literal: true

module ApplicationHelper
  def nl2br(str)
    str&.gsub(/\r?\n/, "<br>\n")
  end

  # HTMLを安全に出力するヘルパー
  def safe_html(text)
    return '' if text.blank?

    sanitize(text,
             tags: %w[
               a abbr b blockquote br caption cite code col colgroup dd div dl dt em h1 h2 h3 h4 h5 h6 hr i img
               li ol p pre q small span strong sub sup table tbody td tfoot th thead tr u ul
             ],
             attributes: %w[
               href src alt title width height class id name colspan rowspan align valign
             ])
  end

  # for admin pages
  def snm_link(label, href: nil, font_color: 'sidebar', icon: nil, button_style: 'primary', target: nil)
    render(Admin::SnmLinkComponent.new(label:, href:, font_color:, icon:, button_style:, target:))
  end

  def snm_headline(h:, &) # rubocop:disable Naming/MethodParameterName
    render(Admin::SnmHeadlineComponent.new(h:), &)
  end
end
