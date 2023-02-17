# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class WorkersTableComponent < ViewComponent::Base
    def initialize(workers:)
      super
      @header = %w[工作員ID 姓名 読み]
      @workers = workers
    end
  end
end
