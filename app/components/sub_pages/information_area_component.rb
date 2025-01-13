# frozen_string_literal: true

module SubPages
  # トップページ埋め込み用コンポーネント(お知らせ)
  class InformationAreaComponent < ViewComponent::Base
    def initialize(new_works_published_on:, new_works:, latest_news_entry:)
      super
      @new_works_published_on = new_works_published_on
      @new_works = new_works
      @latest_news_entry = latest_news_entry
    end

    attr_reader :new_works_published_on, :new_works, :latest_news_entry
  end
end
