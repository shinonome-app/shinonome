# frozen_string_literal: true

module Admin
  module Works
    class WorkerAssignsController < ::Admin::ApplicationController
      include Pagy::Backend
      before_action :set_work

      # GET /admin/works/:work_id/worker_assigns
      def index
        return unless params[:text]

        @pagy, @workers =
          pagy(Worker
                 .with_name_kana_search(params[:name_kana],
                                        params[:text_selector_name_kana])
                 .with_name_search(params[:name],
                                   params[:text_selector_name])
                 .order(created_at: :desc),
               items: 50)
      end

      # GET /admin/works/:work_id/worker_assigns/new
      def new
        @worker = Worker.new
        @worker.work_workers.build(work_id: params[:work_id], worker_role_id: params[:worker_role_id])
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_work
        @work = Work.find(params[:work_id])
      end

      def set_worker
        @worker = Worker.find(params[:worker_id])
      end
    end
  end
end
