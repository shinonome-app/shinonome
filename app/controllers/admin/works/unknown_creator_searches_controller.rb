# frozen_string_literal: true

module Admin
  module Works
    class UnknownCreatorSearchesController < ApplicationController
      include Pagy::Backend

      # GET /admin/works/unknown_creator_searches
      def index
        @pagy, @works = pagy(Work.without_authors.order(created_at: :desc), limit: 50)
      end
    end
  end
end
