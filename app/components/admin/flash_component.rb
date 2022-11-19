# frozen_string_literal: true

module Admin
  # flash表示用
  class FlashComponent < ViewComponent::Base
    FLASH_CLASS = {
      'notice' => 'bg-blue-200 border-blue-400 text-blue-700',
      'success' => 'bg-green-100 border-green-400 text-green-700',
      'alert' => 'bg-red-100 border-red-400 text-red-700'
    }.freeze

    FLASH_ICON = {
      'notice' => 'ℹ️',
      'success' => '✅',
      'alert' => '⚠️️'
    }.freeze

    attr_reader :flash

    def initialize(flash:)
      super
      @flash = flash
    end

    def flash_class(type)
      FLASH_CLASS[type]
    end

    def flash_icon(type)
      FLASH_ICON[type]
    end
  end
end
