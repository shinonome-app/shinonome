# frozen_string_literal: true

module Admin
  class WorkersController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_worker, only: %i[show edit update destroy]

    # GET /admin/workers
    def index
      @pagy, @workers = pagy(Worker.all)
    end

    # GET /admin/workers/1
    def show
      @work_workers = WorkWorker.preload(:worker_role, work: %i[kana_type work_status]).where(worker_id: @worker.id).order(updated_at: :desc)
    end

    # GET /admin/workers/new
    def new
      @worker = Worker.new
      @worker.worker_secret = WorkerSecret.new
    end

    # GET /admin/workers/1/edit
    def edit
      @worker = Worker.find(params[:id])
    end

    # POST /admin/workers
    def create
      worker_params[:worker_secret_attributes].merge!({ user_id: current_admin_user.id })

      @worker = Worker.new(worker_params)
      if @worker.save
        redirect_to [:admin, @worker], success: '追加しました'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/workers/1
    def update
      worker_params[:worker_secret_attributes].merge!({ user_id: current_admin_user.id })
      if @worker.update(worker_params)
        redirect_to [:admin, @worker], success: '更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/workers/1
    def destroy
      @worker.destroy
      redirect_to admin_workers_url, success: '削除しました.'
    end

    private

    def set_worker
      @worker = Worker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def worker_params
      params.require(:worker).permit(:name, :name_kana, :sortkey, { worker_secret_attributes: %i[url email note id], work_workers_attributes: %i[work_id worker_role_id] })
    end
  end
end
