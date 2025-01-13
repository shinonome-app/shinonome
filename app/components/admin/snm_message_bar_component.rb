# frozen_string_literal: true

module Admin
  # flash message用コンポーネント
  class SnmMessageBarComponent < ViewComponent::Base
    STYLE_CLASSES = {
      notice: 'text-sky-950 bg-sky-200 text-sm px-8 py-3 rounded mb-2',
      success: 'text-green-950 bg-green-200 text-sm px-8 py-3 rounded mb-2',
      alert: 'text-rose-950 bg-rose-300 text-sm px-8 py-3 rounded mb-2'
    }.freeze

    def initialize(level: nil)
      super
      @level = (level || :notice).to_sym
    end

    private

    attr_reader :level

    def style_classes
      STYLE_CLASSES[level]
    end
  end
end
