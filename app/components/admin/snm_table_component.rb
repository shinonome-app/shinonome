# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class SnmTableComponent < ViewComponent::Base
    def initialize(header:, body:)
      super
      @header = header
      @body = body
    end
  end
end
