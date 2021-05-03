# frozen_string_literal: true

module Admin
  class WorkersController < ApplicationController
    before_action :set_worker, only: %i[show edit update destroy]

    # GET /workers
    def index
      @workers = Worker.all
    end

    # GET /workers/1
    def show
      @books = Book.where(worker: @worker).order(updated_at: :desc)
    end

    # GET /workers/new
    def new
      @worker = Worker.new
    end

    # GET /workers/1/edit
    def edit
      @worker = Worker.find(params[:id])
    end

    # POST /workers
    def create
      @worker = Worker.new(worker_params)

      if @worker.save
        redirect_to [:admin, @worker], notice: '工作員を追加しました'
      else
        render :new
      end
    end

    # PATCH/PUT /workers/1
    def update
      if @worker.update(worker_params)
        redirect_to [:admin, @worker], notice: 'Worker was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /workers/1
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
      params.require(:worker).permit(:name, :name_kana, :url, :email, :sortkey, :note)
    end
  end
end
