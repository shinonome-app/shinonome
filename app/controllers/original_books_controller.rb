class OriginalBooksController < ApplicationController
  before_action :set_original_book, only: [:show, :edit, :update, :destroy]

  # GET /original_books
  def index
    @original_books = OriginalBook.all
  end

  # GET /original_books/1
  def show
  end

  # GET /original_books/new
  def new
    @original_book = OriginalBook.new
  end

  # GET /original_books/1/edit
  def edit
  end

  # POST /original_books
  def create
    @original_book = OriginalBook.new(original_book_params)

    if @original_book.save
      redirect_to @original_book, notice: 'Original book was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /original_books/1
  def update
    if @original_book.update(original_book_params)
      redirect_to @original_book, notice: 'Original book was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /original_books/1
  def destroy
    @original_book.destroy
    redirect_to original_books_url, notice: 'Original book was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_original_book
      @original_book = OriginalBook.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def original_book_params
      params.require(:original_book).permit(:book_id, :title, :publisher, :first_pubyear, :input_edition, :proof_edition, :booktype_name, :note)
    end
end
