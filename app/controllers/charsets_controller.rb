class CharsetsController < ApplicationController
  before_action :set_charset, only: %i[show edit update destroy]

  # GET /charsets
  def index
    @charsets = Charset.all
  end

  # GET /charsets/1
  def show; end

  # GET /charsets/new
  def new
    @charset = Charset.new
  end

  # GET /charsets/1/edit
  def edit; end

  # POST /charsets
  def create
    @charset = Charset.new(charset_params)

    if @charset.save
      redirect_to @charset, notice: 'Charset was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /charsets/1
  def update
    if @charset.update(charset_params)
      redirect_to @charset, notice: 'Charset was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /charsets/1
  def destroy
    @charset.destroy
    redirect_to charsets_url, notice: 'Charset was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_charset
    @charset = Charset.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def charset_params
    params.require(:charset).permit(:name)
  end
end
