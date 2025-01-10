# frozen_string_literal: true

module ApplicationHelper
  def nl2br(str)
    str&.gsub(/\r?\n/, "<br>\n")
  end

  # for admin pages
  def snm_link(label, href: nil, font_color: 'sidebar', icon: nil, button_style: 'primary', target: nil)
    render(Admin::SnmLinkComponent.new(label:, href:, font_color:, icon:, button_style:, target:))
  end

  def snm_headline(h:, &) # rubocop:disable Naming/MethodParameterName
    render(Admin::SnmHeadlineComponent.new(h:), &)
  end
end
