# frozen_string_literal: true

module Admin
  module Books
    class WorkerAssignsController < ::Admin::ApplicationController
      include Pagy::Backend
      before_action :set_book

      # GET /admin/books/:book_id/worker_assigns
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

      # GET /admin/books/:book_id/worker_assigns/new
      def new
        @worker = Worker.new
        @worker.book_workers.build(book_id: params[:book_id], worker_role_id: params[:worker_role_id])
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_book
        @book = Book.find(params[:book_id])
      end

      def set_worker
        @worker = Worker.find(params[:worker_id])
      end
    end
  end
end
