# frozen_string_literal: true

module Admin
  # date_select用コンポーネント
  class SnmDateFieldComponent < ViewComponent::Base
    def initialize(form:, name:, label: nil, value: nil, options: nil, html_options: {}, errors: nil, error_key: nil)
      super
      @form = form
      @name = name
      @value = value || Time.zone.today
      @label = label || form.object.class.human_attribute_name(name)
      @options = options

      default_class = {
        class: 'w-full min-w-[100px] bg-dropdownIcon bg-no-repeat bg-[right_0.8rem_center] rounded px-2 py-2 border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] cursor-pointer appearance-none'
      }
      @html_options = default_class.merge(html_options)

      @errors = errors || {}
      @error_key = error_key || name
    end

    attr_reader :form, :name, :value, :label, :options, :html_options, :errors, :error_key
  end
end
