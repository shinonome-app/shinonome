class FileEncodingsController < ApplicationController
  before_action :set_file_encoding, only: [:show, :edit, :update, :destroy]

  # GET /file_encodings
  def index
    @file_encodings = FileEncoding.all
  end

  # GET /file_encodings/1
  def show
  end

  # GET /file_encodings/new
  def new
    @file_encoding = FileEncoding.new
  end

  # GET /file_encodings/1/edit
  def edit
  end

  # POST /file_encodings
  def create
    @file_encoding = FileEncoding.new(file_encoding_params)

    if @file_encoding.save
      redirect_to @file_encoding, notice: 'File encoding was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /file_encodings/1
  def update
    if @file_encoding.update(file_encoding_params)
      redirect_to @file_encoding, notice: 'File encoding was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /file_encodings/1
  def destroy
    @file_encoding.destroy
    redirect_to file_encodings_url, notice: 'File encoding was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_file_encoding
      @file_encoding = FileEncoding.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def file_encoding_params
      params.require(:file_encoding).permit(:name)
    end
end
