# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class SnmTableComponent < ViewComponent::Base
    DEFAULT_TD_CLASS = 'text-center py-0 px-5'

    def initialize(header:, body:, classes: nil)
      super
      @header = header
      @body = body
      @classes = classes || ([DEFAULT_TD_CLASS] * @body.size)
    end
  end
end
