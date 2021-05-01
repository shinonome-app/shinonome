# frozen_string_literal: true

class Admin::NaviComponent < ViewComponent::Base
  def initialize(title:)
    @title = title
  end
end
