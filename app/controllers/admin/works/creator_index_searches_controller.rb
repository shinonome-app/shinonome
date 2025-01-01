# frozen_string_literal: true

module Admin
  module Works
    class CreatorIndexSearchesController < ApplicationController
      include Pagy::Backend

      # GET /admin/works/creator_index_searches
      def index
        char = params[:creator]

        @pagy, @works = pagy(Work.with_creator_firstchar(char).order(created_at: :desc), limit: 50)
      end
    end
  end
end
