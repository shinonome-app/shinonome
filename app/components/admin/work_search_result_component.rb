# frozen_string_literal: true

module Admin
  # 作品検索結果一覧用コンポーネント
  class WorkSearchResultComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(works:, pagy:)
      super
      @works = works
      @pagy = pagy
    end
  end
end
