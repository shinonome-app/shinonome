# frozen_string_literal: true

module SubPages
  # トップページ埋め込み用コンポーネント（資料室）
  class ResourceAreaComponent < ViewComponent::Base
    def initialize(topics:)
      super
      @topics = topics
    end

    attr_reader :topics
  end
end
