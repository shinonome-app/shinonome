# frozen_string_literal: true

module Admin
  class WorkWorkersController < Admin::ApplicationController
    before_action :set_work_worker, only: %i[destroy]

    # POST /admin/work_workers
    def create
      @work_worker = WorkWorker.new(work_worker_params)

      if @work_worker.save
        redirect_to admin_work_url(@work_worker.work), notice: 'Work worker was successfully created.'
      else
        redirect_to admin_work_url(@work_worker.work)
      end
    end

    # DELETE /admin/work_workers/1
    def destroy
      work = @work_worker.work
      @work_worker.destroy
      redirect_to admin_work_url(work), notice: 'Work worker was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_work_worker
      @work_worker = WorkWorker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_worker_params
      params.require(:work_worker).permit(:work_id, :worker_id, :worker_role_id)
    end
  end
end