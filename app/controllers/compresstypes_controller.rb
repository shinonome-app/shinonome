# frozen_string_literal: true

class CompresstypesController < ApplicationController
  before_action :set_compresstype, only: %i[show edit update destroy]

  # GET /compresstypes
  def index
    @compresstypes = Compresstype.all
  end

  # GET /compresstypes/1
  def show; end

  # GET /compresstypes/new
  def new
    @compresstype = Compresstype.new
  end

  # GET /compresstypes/1/edit
  def edit; end

  # POST /compresstypes
  def create
    @compresstype = Compresstype.new(compresstype_params)

    if @compresstype.save
      redirect_to @compresstype, notice: 'Compresstype was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /compresstypes/1
  def update
    if @compresstype.update(compresstype_params)
      redirect_to @compresstype, notice: 'Compresstype was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /compresstypes/1
  def destroy
    @compresstype.destroy
    redirect_to compresstypes_url, notice: 'Compresstype was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_compresstype
    @compresstype = Compresstype.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def compresstype_params
    params.require(:compresstype).permit(:name, :extension)
  end
end
