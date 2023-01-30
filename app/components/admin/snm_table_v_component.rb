# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class SnmTableVComponent < ViewComponent::Base
    def initialize(rows:)
      super
      @rows = rows
    end
  end
end
