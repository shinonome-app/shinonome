# frozen_string_literal: true

module Admin
  # 関連サイト検索用フォーム
  class SiteSearchComponent < ViewComponent::Base
    attr_reader :form_url

    def initialize(form_url:)
      super
      @form_url = form_url
    end
  end
end
