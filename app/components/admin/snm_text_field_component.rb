# frozen_string_literal: true

module Admin
  # text_field用コンポーネント
  class SnmTextFieldComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, field_type: nil, errors: nil, error_key: nil)
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @field_type = field_type
      @errors = errors || {}
      @error_key = error_key || name
    end

    def input_class
      'text-gray-600 w-full border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] invalid:border-pink-500 invalid:text-pink-600 rounded outline-none transition duration-100 px-2 py-2'
    end

    attr_reader :form, :name, :label, :field_type, :errors, :error_key
  end
end
