# frozen_string_literal: true

module Admin
  class BookfilesController < ApplicationController
    before_action :set_bookfile, only: %i[show edit update destroy]

    # GET /bookfiles
    def index
      @bookfiles = Bookfile.all
    end

    # GET /bookfiles/1
    def show; end

    # GET /bookfiles/new
    def new
      @bookfile = Bookfile.new
    end

    # GET /bookfiles/1/edit
    def edit; end

    # POST /bookfiles
    def create
      @bookfile = Bookfile.new(bookfile_params)

      if @bookfile.save
        redirect_to @bookfile, notice: 'Bookfile was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /bookfiles/1
    def update
      if @bookfile.update(bookfile_params)
        redirect_to @bookfile, notice: 'Bookfile was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /bookfiles/1
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
                                       :opened_on, :fixnum, :file_encoding_id, :charset_id, :note)
    end
  end
end
