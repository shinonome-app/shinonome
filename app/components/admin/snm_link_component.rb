# frozen_string_literal: true

module Admin
  # リンク用コンポーネント
  class SnmLinkComponent < ViewComponent::Base
    FONT_STYLE = {
      nav: 'text-ab_font_black hover:text-blue-800 text-xs small-screen-hidden',
      sidebar: 'w-full whitespace-nowrap text-white hover:text-ab_font_black text-sm hover:bg-[#95A1CB] px-2 py-3 rounded-md'
    }.freeze

    ALLOWED_ICONS = %w[
      home
      notice
      user
      work
      person
      worker
      website
      db
      file
      mail
      pen
      command
      roller
      admin
    ].freeze

    def initialize(label: nil, href: nil, button_style: nil, font_color: nil, icon: nil, target: nil)
      super

      # icon の値が許可リストに含まれているかチェック
      raise ArgumentError, "Invalid icon name: #{icon}. Allowed icons are: #{ALLOWED_ICONS.join(', ')}" if icon.present? && ALLOWED_ICONS.exclude?(icon)

      @label = label
      @button_style = button_style
      @font_color = font_color
      @href = href
      @icon = icon
      @target = target
    end

    private

    attr_reader :button_style, :font_color, :href, :icon, :target, :label

    # rubocop:disable Layout/LineLength
    def style_class
      button_styles = {
        primary: 'snm-link grid bg-ab_primary border-2 border-white hover:bg-ab_primary_hover hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#ebf8ff] active:bg-ab_primary_hover focus-visible:ring ring-gray-300 text-white text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer',
        secondary: 'snm-link grid bg-white border-2 border-gray hover:bg-white hover:border-2 hover:border-gray hover:shadow-[0px_2px_18px_0px_#edf2f7] active:bg-white focus-visible:ring ring-gray-300 text-zinc-700 text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer',
        alert: 'snm-link grid bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-sm font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer',
        normal: "snm-link inline-flex items-center #{font_style} space-x-2"
      }

      button_styles[button_style.to_sym]
    end
    # rubocop:enable Layout/LineLength

    def font_style
      FONT_STYLE[font_color.to_sym]
    end

    def icon_svg
      return if icon.blank?

      file_path = Rails.root.join('app/assets/icons', "#{icon}.svg")
      if File.exist?(file_path)
        File.read(file_path).html_safe # rubocop:disable Rails/OutputSafety
      else
        Rails.logger.warn("SVG file not found: #{file_path}")
        nil
      end
    end
  end
end
