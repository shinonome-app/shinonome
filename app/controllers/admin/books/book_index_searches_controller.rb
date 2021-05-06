# frozen_string_literal: true

module Admin
  module Books
    class BookIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/books/book_index_searches
      def index
        char = params[:book]

        @pagy, @books = pagy(Book.with_title_firstchar(char).order(created_at: :desc), items: 50)
      end
    end
  end
end
