# frozen_string_literal: true

module Admin
  module Workers
    class WorkerIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/workers/worker_index_searches
      def index
        char = params[:worker]
        scope = Worker.with_name_firstchar(char).order(created_at: :desc)

        @show_all = params[:all].present?
        limit = @show_all ? [scope.count, 1].max : LIST_LIMIT
        @pagy, @workers = pagy(scope, limit:)
      end
    end
  end
end
