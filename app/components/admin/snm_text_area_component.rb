# frozen_string_literal: true

module Admin
  # text_area用コンポーネント
  class SnmTextAreaComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, rows: nil, errors: nil)
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @rows = rows || 5
      @errors = errors || {}
    end

    attr_reader :form, :name, :label, :rows, :errors
  end
end
