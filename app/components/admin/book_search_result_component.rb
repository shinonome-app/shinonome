# frozen_string_literal: true

module Admin
  # 作品検索結果一覧用コンポーネント
  class BookSearchResultComponent < ViewComponent::Base
    include ::Pagy::Frontend

    def initialize(books:, pagy:)
      super
      @books = books
      @pagy = pagy
    end
  end
end
