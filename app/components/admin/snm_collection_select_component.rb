# frozen_string_literal: true

module Admin
  # collection_select用コンポーネント
  class SnmCollectionSelectComponent < ViewComponent::Base
    def initialize(form:, name:, collection:, value_method:, text_method:, label:, options: nil, html_options: nil, errors: nil) # rubocop:disable Metrics/ParameterLists
      super
      @form = form
      @name = name
      @collection = collection
      @value_method = value_method
      @text_method = text_method
      @label = label
      @options = options || { prompt: '選択してください' }

      default_class = {
        class: "w-full min-w-[100px] bg-[url('/images/svg/dropdown.svg')] bg-no-repeat bg-[right_0.8rem_center] rounded px-2 py-2 border border-ab_form focus:outline-none focus:border-ab_focus focus:ring-1 focus:ring-ab_focus focus:shadow-[0px_1px_13px_0px_#bee3f8] cursor-pointer appearance-none"
      }
      @html_options = html_options ? default_class.merge(html_options) : default_class

      @errors = errors || {}
    end

    attr_reader :form, :name, :collection, :value_method, :text_method, :label, :options, :html_options, :errors
  end
end
