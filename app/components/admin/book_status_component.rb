# frozen_string_literal: true

module Admin
  # 作品状態入力用コンポーネント
  class BookStatusComponent < ViewComponent::Base
    def initialize(form:, years:)
      super
      @form = form
      @years = years
    end
  end
end
