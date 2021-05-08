# frozen_string_literal: true

module Admin
  # 作品テキスト検索フォーム用
  class TextSearchInputComponent < ViewComponent::Base
    def initialize(form:, label:, name:, value: nil)
      super
      @form = form
      @label = label
      @name = name
      @value = value
    end
  end
end
