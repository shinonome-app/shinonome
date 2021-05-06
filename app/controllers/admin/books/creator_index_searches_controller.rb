# frozen_string_literal: true

module Admin
  module Books
    class CreatorIndexSearchesController < ApplicationController
      include Pagy::Backend

      # GET /admin/books/creator_index_searches
      def index
        char = params[:creator]

        @pagy, @books = pagy(Book.with_creator_firstchar(char).order(created_at: :desc), items: 50)
      end
    end
  end
end
