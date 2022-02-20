# frozen_string_literal: true

module Admin
  module Works
    class WorkIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/works/work_index_searches
      def index
        char = params[:work]

        @pagy, @works = pagy(Work.with_title_firstchar(char).order(created_at: :desc), items: 50)
      end
    end
  end
end
