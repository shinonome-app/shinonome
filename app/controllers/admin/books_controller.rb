# frozen_string_literal: true

module Admin
  # 作品管理
  class BooksController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_book, only: %i[show edit update destroy]

    TEXT_SELECTOR = [
      ['を含む', 1],
      ['で始まる', 2],
      ['で終わる', 3],
      ['と等しい', 4]
    ]

    # GET /books
    def index
      @pagy, @books = pagy(Book.order(:id).all, items: 50)
      @years = (1995..Time.zone.now.year).to_a
    end

    # GET /books/1
    def show; end

    # GET /books/new
    def new
      @book = Book.new
    end

    # GET /books/1/edit
    def edit; end

    # POST /books
    def create
      @book = Book.new(book_params)

      if @book.save
        redirect_to [:admin, @book], notice: 'Book was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /books/1
    def update
      if @book.update(book_params)
        redirect_to [:admin, @book], notice: 'Book was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /books/1
    def destroy
      @book.destroy
      redirect_to admin_books_url, notice: 'Book was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def book_params
      params.require(:book).permit(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                   :original_title, :kana_type_id, :author_display_name, :first_appearance, :description,
                                   :description_person_id, :status, :started_on, :copyright_flag, :note, :orig_text,
                                   :updated_at, :user_id, :update_flag, :sortkey)
    end
  end
end
