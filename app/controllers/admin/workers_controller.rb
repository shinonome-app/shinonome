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
      @works = Work.where(worker: @worker).order(updated_at: :desc)
    end

    # GET /admin/workers/new
    def new
      @worker = Worker.new
    end

    # GET /admin/workers/1/edit
    def edit
      @worker = Worker.find(params[:id])
    end

    # POST /admin/workers
    def create
      @worker = Worker.new(worker_params)
      @worker.user_id = current_admin_user.id
      if @worker.save
        redirect_to [:admin, @worker], notice: '工作員を追加しました'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/workers/1
    def update
      worker_params[:worker_secret_attributes].merge!({user_id: current_admin_user.id})
      if @worker.update(worker_params)
        redirect_to [:admin, @worker], notice: 'Worker was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/workers/1
    def destroy
      @worker.destroy
      redirect_to admin_workers_url, notice: 'Worker was successfully destroyed.'
    end

    private

    def set_worker
      @worker = Worker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def worker_params
      params.require(:worker).permit(:name, :name_kana, :sortkey, { worker_secret_attributes: [:url, :email, :note, :id], work_workers_attributes: %i[work_id worker_role_id] })
    end
  end
end
