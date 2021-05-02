# frozen_string_literal: true

module Admin
  class NaviComponent < ViewComponent::Base
    def initialize(title:)
      @title = title
    end
  end
end
