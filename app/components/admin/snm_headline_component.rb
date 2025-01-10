# frozen_string_literal: true

module Admin
  # 見出し用コンポーネント
  class SnmHeadlineComponent < ViewComponent::Base
    STYLE_TABLE = {
      h1: 'w-full text-2xl mb-5 p-3 inline-block font-bold bg-ab_bg_gray border-l-4 border-solid border-ab_navy',
      h2: 'w-full text-xl mb-2 py-1 px-2 font-bold bg-transparent border-l-4 border-solid border-ab_navy',
      h3: 'text-lg mt-5 mb-2 font-bold'
    }.freeze

    renders_one :logo

    def initialize(h:) # rubocop:disable Naming/MethodParameterName
      super
      @h = h
    end

    private

    def level
      @h
    end

    def style_classes
      STYLE_TABLE[@h.to_sym]
    end
  end
end
