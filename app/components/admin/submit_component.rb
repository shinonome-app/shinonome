# frozen_string_literal: true

module Admin
  # ナビゲーション用コンポーネント
  class SubmitComponent < ViewComponent::Base
    # rubocop:disable Layout/LineLength
    BUTTON_STYLE = {
      primary: 'grid w-full bg-ab_primary border-2 border-white hover:bg-ab_primary_hover hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#ebf8ff] active:bg-ab_primary_hover focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer',
      secondary: 'grid w-full bg-white border-2 border-gray hover:bg-white hover:border-2 hover:border-gray hover:shadow-[0px_2px_18px_0px_#edf2f7] active:bg-white focus-visible:ring ring-gray-300 text-zinc-700 text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer',
      alert: 'grid w-full bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer'
    }.freeze
    # rubocop:enable Layout/LineLength

    def initialize(name:, value:, button_style: :primary)
      super
      @name = name
      @value = value
      @button_style = button_style
    end

    def button_style_class
      BUTTON_STYLE[@button_style] || ''
    end
  end
end
