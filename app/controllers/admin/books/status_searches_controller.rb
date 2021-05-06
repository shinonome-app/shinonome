# frozen_string_literal: true

module Admin
  module Books
    class StatusSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/books/status_searches
      def index
        status = params[:status]
        year = params[:year]

        @pagy, @books = pagy(Book.with_year_and_status(year, status).order(created_at: :desc), items: 50)
      end
    end
  end
end
