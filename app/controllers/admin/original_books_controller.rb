# frozen_string_literal: true

module Admin
  class OriginalBooksController < Admin::ApplicationController
    before_action :set_original_book, only: %i[edit update destroy]
    before_action :set_book

    # GET /admin/original_books/new
    def new
      @original_book = OriginalBook.new
    end

    # GET /admin/original_books/1/edit
    def edit; end

    # POST /admin/original_books
    def create
      @original_book = OriginalBook.new(original_book_params)
      @original_book.book = @book
      if @original_book.save
        redirect_to admin_book_url(@book), notice: 'Original book was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/original_books/1
    def update
      if @original_book.update(original_book_params)
        redirect_to admin_book_url(@book), notice: 'Original book was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/original_books/1
    def destroy
      @original_book.destroy
      redirect_to admin_book_url(@book), notice: 'Original book was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_original_book
      @original_book = OriginalBook.find(params[:id])
    end

    def set_book
      @book = Book.find(params[:book_id])
    end

    # Only allow a list of trusted parameters through.
    def original_book_params
      params.require(:original_book).permit(:book_id, :title, :publisher, :first_pubdate, :input_edition,
                                            :proof_edition, :booktype_id, :note)
    end
  end
end
