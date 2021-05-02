# frozen_string_literal: true

class FiletypesController < ApplicationController
  before_action :set_filetype, only: %i[show edit update destroy]

  # GET /filetypes
  def index
    @filetypes = Filetype.all
  end

  # GET /filetypes/1
  def show; end

  # GET /filetypes/new
  def new
    @filetype = Filetype.new
  end

  # GET /filetypes/1/edit
  def edit; end

  # POST /filetypes
  def create
    @filetype = Filetype.new(filetype_params)

    if @filetype.save
      redirect_to @filetype, notice: 'Filetype was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /filetypes/1
  def update
    if @filetype.update(filetype_params)
      redirect_to @filetype, notice: 'Filetype was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /filetypes/1
  def destroy
    @filetype.destroy
    redirect_to filetypes_url, notice: 'Filetype was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_filetype
    @filetype = Filetype.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def filetype_params
    params.require(:filetype).permit(:name, :extension)
  end
end
