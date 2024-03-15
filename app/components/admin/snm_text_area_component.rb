# frozen_string_literal: true

module Admin
  # text_area用コンポーネント
  class SnmTextAreaComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, rows: nil, errors: nil, error_key: nil)
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @rows = rows || 10
      @errors = errors || {}
      @error_key = error_key || name
    end

    attr_reader :form, :name, :label, :rows, :errors, :error_key
  end
end
