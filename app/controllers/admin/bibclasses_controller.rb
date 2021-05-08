# frozen_string_literal: true

module Admin
  class BibclassesController < Admin::ApplicationController
    before_action :set_bibclass, only: %i[show edit update destroy]

    # GET /admin/books/:book_id/bibclasses
    def index
      @bibclasses = Bibclass.all
    end

    # GET /admin/books/:book_id/bibclasses/1
    def show; end

    # GET /admin/books/:book_id/bibclasses/new
    def new
      @bibclass = Bibclass.new
      @bibclass.book_id = params[:book_id] if params[:book_id]
    end

    # GET /admin/books/:book_id/bibclasses/1/edit
    def edit; end

    # POST /admin/books/:book_id/bibclasses
    def create
      @bibclass = Bibclass.new(bibclass_params)

      if @bibclass.save
        redirect_to [:admin, @bibclass.book], notice: 'Bibclass was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/books/:book_id/bibclasses/1
    def update
      if @bibclass.update(bibclass_params)
        redirect_to [:admin, @bibclass.book], notice: 'Bibclass was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/books/:book_id/bibclasses/1
    def destroy
      book = @bibclass.book
      @bibclass.destroy
      redirect_to [:admin, book], notice: 'Bibclass was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_bibclass
      @bibclass = Bibclass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibclass_params
      params.require(:bibclass).permit(:name, :note, :num, :book_id)
    end
  end
end
