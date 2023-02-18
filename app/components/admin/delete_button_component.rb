# frozen_string_literal: true

module Admin
  # 削除ボタン用コンポーネント
  class DeleteButtonComponent < ViewComponent::Base
    def initialize(url:, options: {})
      super
      @url = url
      default_options = {
        class: 'grid bg-ab_alert border-2 border-white hover:bg-ab_alert hover:border-2 hover:border-white hover:shadow-[0px_2px_18px_0px_#fed7e2] active:bg-ab_alert focus-visible:ring ring-gray-300 text-white text-base font-semibold text-center rounded-lg outline-none transition duration-100 px-8 py-3 mb-2 cursor-pointer'
      }
      @options = default_options.merge(options)
    end

    attr_reader :url, :options
  end
end
