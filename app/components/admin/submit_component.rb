# frozen_string_literal: true

module Admin
  # ナビゲーション用コンポーネント
  class SubmitComponent < ViewComponent::Base
    def initialize(name:, value:)
      super
      @name = name
      @value = value
    end
  end
end
