# frozen_string_literal: true

module Admin
  module Works
    class StatusSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/works/status_searches
      def index
        status = params[:status]
        year = params[:year]

        @pagy, @works = pagy(Work.with_year_and_status(year, status).order(created_at: :desc), limit: 50)
      end
    end
  end
end
