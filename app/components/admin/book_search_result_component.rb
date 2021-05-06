# frozen_string_literal: true

class Admin::BookSearchResultComponent < ViewComponent::Base
  include ::Pagy::Frontend

  def initialize(books:, pagy:)
    @books = books
    @pagy = pagy
  end
end
