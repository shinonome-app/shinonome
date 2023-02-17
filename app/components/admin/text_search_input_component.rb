# frozen_string_literal: true

module Admin
  # 作品テキスト検索フォーム用
  class TextSearchInputComponent < ViewComponent::Base
    include TailwindHelper

    def initialize(form:, label:, name:, error: nil, value: nil)
      super
      @form = form
      @label = label
      @name = name
      @value = value
      @error = error
    end
  end
end
