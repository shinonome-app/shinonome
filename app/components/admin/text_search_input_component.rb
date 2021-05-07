# frozen_string_literal: true

module Admin
  # 作品テキスト検索フォーム用
  class TextSearchInputComponent < ViewComponent::Base
    def initialize(form:, label:, name:)
      super
      @form = form
      @label = label
      @name = name
    end
  end
end
