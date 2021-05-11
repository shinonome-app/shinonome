# frozen_string_literal: true

module Admin
  class BookWorkersController < Admin::ApplicationController
    before_action :set_book_worker, only: %i[destroy]

    # POST /admin/book_workers
    def create
      @book_worker = BookWorker.new(book_worker_params)

      if @book_worker.save
        redirect_to admin_book_url(@book_worker.book), notice: 'Book worker was successfully created.'
      else
        render :new
      end
    end

    # DELETE /admin/book_workers/1
    def destroy
      book = @book_worker.boook
      @book_worker.destroy
      redirect_to admin_book_url(book), notice: 'Book worker was successfully destroyed.'
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
end
