# frozen_string_literal: true

module Admin
  module WorkWorkers
    class BindsController < ::Admin::ApplicationController
      # POST /admin/work/:work_id/work_workers/binds
      def create
        @work_worker = WorkWorker.new(work_id: params[:work_id], worker_id: params[:worker_id], worker_role_id: params[:worker_role_id])
        @work_worker.save!

        redirect_to [:admin, @work_worker.work], notice: '関連づけました.'
      rescue ActiveRecord::RecordInvalid
        redirect_to admin_work_path(params[:work_id]), notice: @work_worker.errors.full_messages.join
      rescue RuntimeError
        render '/admin/work_workers/new', status: :unprocessable_entity
      end
    end
  end
end
