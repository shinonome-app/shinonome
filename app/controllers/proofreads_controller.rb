class ProofreadsController < ApplicationController
  before_action :set_proofread, only: [:show, :edit, :update, :destroy]

  # GET /proofreads
  def index
    @proofreads = Proofread.all
  end

  # GET /proofreads/1
  def show
  end

  # GET /proofreads/new
  def new
    @proofread = Proofread.new
  end

  # GET /proofreads/1/edit
  def edit
  end

  # POST /proofreads
  def create
    @proofread = Proofread.new(proofread_params)

    if @proofread.save
      redirect_to @proofread, notice: 'Proofread was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /proofreads/1
  def update
    if @proofread.update(proofread_params)
      redirect_to @proofread, notice: 'Proofread was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /proofreads/1
  def destroy
    @proofread.destroy
    redirect_to proofreads_url, notice: 'Proofread was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_proofread
      @proofread = Proofread.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proofread_params
      params.require(:proofread).permit(:book_id, :book_copy, :book_print, :refbook, :bookfile_id, :address, :memo, :worker_id, :woker_kana, :worker_name, :email, :url, :person_id, :sts1, :sts2)
    end
end
