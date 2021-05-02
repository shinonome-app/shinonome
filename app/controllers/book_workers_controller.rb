class BookWorkersController < ApplicationController
  before_action :set_book_worker, only: %i[show edit update destroy]

  # GET /book_workers
  def index
    @book_workers = BookWorker.all
  end

  # GET /book_workers/1
  def show; end

  # GET /book_workers/new
  def new
    @book_worker = BookWorker.new
  end

  # GET /book_workers/1/edit
  def edit; end

  # POST /book_workers
  def create
    @book_worker = BookWorker.new(book_worker_params)

    if @book_worker.save
      redirect_to @book_worker, notice: 'Book worker was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /book_workers/1
  def update
    if @book_worker.update(book_worker_params)
      redirect_to @book_worker, notice: 'Book worker was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /book_workers/1
  def destroy
    @book_worker.destroy
    redirect_to book_workers_url, notice: 'Book worker was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book_worker
    @book_worker = BookWorker.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_worker_params
    params.require(:book_worker).permit(:book_id, :worker_id, :worker_role_id)
  end
end
