# frozen_string_literal: true

module Admin
  class BookfilesController < Admin::ApplicationController
    before_action :set_bookfile, only: %i[show edit update destroy]

    # GET /admin/bookfiles
    def index
      @bookfiles = Bookfile.all
    end

    # GET /admin/bookfiles/1
    def show; end

    # GET /admin/bookfiles/new
    def new
      @bookfile = Bookfile.new
      @bookfile.book_id = params[:book_id]
    end

    # GET /admin/bookfiles/1/edit
    def edit; end

    # POST /admin/bookfiles
    def create
      @bookfile = Bookfile.new(bookfile_params)
      @bookfile.user = current_admin_user
      @bookfile.filename = @bookfile.bookdata.filename

      if @bookfile.save
        redirect_to [:admin, @bookfile.book], notice: 'Bookfile was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/bookfiles/1
    def update
      if @bookfile.update(bookfile_params)
        @bookfile.user = current_admin_user
        @bookfile.filename = @bookfile.bookdata.filename
        @bookfile.save!
        redirect_to [:admin, @bookfile.book], notice: 'Bookfile was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/bookfiles/1
    def destroy
      @bookfile.destroy
      redirect_to bookfiles_url, notice: 'Bookfile was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_bookfile
      @bookfile = Bookfile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bookfile_params
      params.require(:bookfile).permit(:book_id, :filetype_id, :compresstype_id, :filesize, :user_id, :url, :filename,
                                       :opened_on, :revision_count, :file_encoding_id, :charset_id, :note, :bookdata)
    end
  end
end
