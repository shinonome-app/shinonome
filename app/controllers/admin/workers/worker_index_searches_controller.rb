# frozen_string_literal: true

module Admin
  module Workers
    class WorkerIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/workers/worker_index_searches
      def index
        char = params[:worker]

        @pagy, @workers = pagy(Worker.with_name_firstchar(char).order(created_at: :desc), limit: 50)
      end
    end
  end
end
