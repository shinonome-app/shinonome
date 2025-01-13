# frozen_string_literal: true

module Admin
  # flash message用コンポーネント
  class SnmMessageBarComponent < ViewComponent::Base
    STYLE_CLASSES = {
      notice: 'text-[#022C45] bg-[#C3E9FF] text-sm px-8 py-3 rounded mb-2',
      success: 'text-[#012B14] bg-[#BFF9D9] text-sm px-8 py-3 rounded mb-2',
      alert: 'text-[#400601] bg-[#FECDC9] text-sm px-8 py-3 rounded mb-2'
    }.freeze

    def initialize(level: :notice)
      super
      @level = level.to_sym
    end

    private

    attr_reader :level

    def style_classes
      STYLE_CLASSES[level]
    end
  end
end
