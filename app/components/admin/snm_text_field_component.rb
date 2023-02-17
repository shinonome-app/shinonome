# frozen_string_literal: true

module Admin
  # text_field用コンポーネント
  class SnmTextFieldComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, errors: nil, error_key: nil)
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @errors = errors || {}
      @error_key = error_key || name
    end

    attr_reader :form, :name, :label, :errors, :error_key
  end
end
