# frozen_string_literal: true

module Admin
  # 工作員検索用フォーム
  class WorkerSearchComponent < ViewComponent::Base
    attr_reader :form_url

    def initialize(form_url:)
      super
      @form_url = form_url
    end
  end
end
