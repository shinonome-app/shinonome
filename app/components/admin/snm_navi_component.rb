# frozen_string_literal: true

module Admin
  # ナビゲーション用コンポーネント
  class SnmNaviComponent < ViewComponent::Base
    def initialize(title:, user:)
      super
      @title = title
      @user = user
    end
  end
end
