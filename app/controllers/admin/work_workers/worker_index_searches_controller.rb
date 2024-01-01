# frozen_string_literal: true

module Admin
  module WorkWorkers
    class WorkerIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/work/:work_id/work_workers/text_searches
      def index
        @work = Work.find(params[:work_id])

        char = params[:worker]
        @pagy, @workers = pagy(Worker.with_name_firstchar(char).order(created_at: :desc), items: 50)
      end
    end
  end
end
