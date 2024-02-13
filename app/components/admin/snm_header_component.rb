# frozen_string_literal: true

module Admin
  # header用コンポーネント
  class SnmHeaderComponent < ViewComponent::Base
    renders_one :logo

    def initialize(title:, user:)
      super
      @title = title
      @user = user
    end

    private

    attr_reader :title, :user
  end
end
