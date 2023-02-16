# frozen_string_literal: true

module Admin
  # text_field用コンポーネント
  class SnmTextFieldComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, errors: nil)
      super
      @form = form
      @name = name
      @label = label
      @errors = errors || {}
    end

    attr_reader :form, :name, :label, :errors
  end
end
