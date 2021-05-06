# frozen_string_literal: true

class Admin::BookStatusComponent < ViewComponent::Base
  def initialize(form:, years:)
    @form = form
    @years = years
  end
end
