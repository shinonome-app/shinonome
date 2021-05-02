# frozen_string_literal: true

module Admin
  class NaviComponent < ViewComponent::Base
    def initialize(title:)
      super
      @title = title
    end
  end
end
