class KanaTypesController < ApplicationController
  before_action :set_kana_type, only: [:show, :edit, :update, :destroy]

  # GET /kana_types
  def index
    @kana_types = KanaType.all
  end

  # GET /kana_types/1
  def show
  end

  # GET /kana_types/new
  def new
    @kana_type = KanaType.new
  end

  # GET /kana_types/1/edit
  def edit
  end

  # POST /kana_types
  def create
    @kana_type = KanaType.new(kana_type_params)

    if @kana_type.save
      redirect_to @kana_type, notice: 'Kana type was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /kana_types/1
  def update
    if @kana_type.update(kana_type_params)
      redirect_to @kana_type, notice: 'Kana type was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kana_types/1
  def destroy
    @kana_type.destroy
    redirect_to kana_types_url, notice: 'Kana type was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_kana_type
      @kana_type = KanaType.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def kana_type_params
      params.require(:kana_type).permit(:name)
    end
end
