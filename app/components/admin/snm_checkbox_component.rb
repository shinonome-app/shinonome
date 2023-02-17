# frozen_string_literal: true

module Admin
  # checkbox用コンポーネント
  class SnmCheckboxComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, options: nil, checked_value: nil, unchecked_value: nil, errors: nil) # rubocop:disable Metrics/ParameterLists
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @options = options || {}
      @checked_value = checked_value || '1'
      @unchecked_value = unchecked_value || '0'
      @errors = errors || {}
    end

    attr_reader :form, :name, :label, :options, :checked_value, :unchecked_value, :errors
  end
end
