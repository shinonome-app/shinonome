# frozen_string_literal: true

module Admin
  # date_select用コンポーネント
  class SnmDateSelectComponent < ViewComponent::Base
    def initialize(form:, name:, label:, start_year:, end_year:, options: {}, html_options: {}, errors: {})
      super
      @form = form
      @name = name
      @label = label || form.object.class.human_attribute_name(name)
      @start_year = start_year
      @end_year = end_year

      default_options = {
        start_year: 1997,
        end_year: Time.zone.now.year + 1,
        date_separator: '-',
        # use_month_numbers: true,
        year_format: ->(year) { "#{year}年" },
        month_format: ->(month) { "#{month}月" },
        day_format: ->(day) { "#{day}日" }
      }
      @options = default_options.merge(options)

      default_html_options = {
        class: 'min-w-[100px] bg-dropdownIcon bg-no-repeat bg-[right_0.8rem_center] rounded px-2 py-2 border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] cursor-pointer appearance-none'
      }
      @html_options = default_html_options.merge(html_options)

      @errors = errors || {}
    end

    attr_reader :form, :name, :label, :options, :html_options, :errors
  end
end
