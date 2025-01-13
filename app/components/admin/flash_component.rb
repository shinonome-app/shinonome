# frozen_string_literal: true

module Admin
  # flash表示用
  class FlashComponent < ViewComponent::Base
    attr_reader :flash

    def initialize(flash:)
      super
      @flash = flash
    end
  end
end
