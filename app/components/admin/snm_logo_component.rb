# frozen_string_literal: true

module Admin
  # ロゴ用コンポーネント
  class SnmLogoComponent < ViewComponent::Base
    def initialize(label:, src:, href:)
      super
      @label = label
      @src = src
      @href = href
    end

    private

    attr_reader :label, :src, :href
  end
end
