class ReceiptsController < ApplicationController
  before_action :set_receipt, only: [:show, :edit, :update, :destroy]

  # GET /receipts
  def index
    @receipts = Receipt.all
  end

  # GET /receipts/1
  def show
  end

  # GET /receipts/new
  def new
    @receipt = Receipt.new
  end

  # GET /receipts/1/edit
  def edit
  end

  # POST /receipts
  def create
    @receipt = Receipt.new(receipt_params)

    if @receipt.save
      redirect_to @receipt, notice: 'Receipt was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /receipts/1
  def update
    if @receipt.update(receipt_params)
      redirect_to @receipt, notice: 'Receipt was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /receipts/1
  def destroy
    @receipt.destroy
    redirect_to receipts_url, notice: 'Receipt was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def receipt_params
      params.require(:receipt).permit(:sakuhinmeiyomi, :sakuhinmei, :fukudaiyomi, :fukudai, :sakuhinshuumeiyomi, :sakuhinshuumei, :gendai, :kana, :shoshutu, :memo, :bikou, :status, :statusdate, :copyright, :seiyomi, :sei, :seieiji, :meiyomi, :mei, :meieiji, :jbikou, :seimeiyomi, :seimei, :email, :url, :bookname, :publisher, :firstversion, :versioninput, :bookname2, :publisher2, :firstversion2, :personid, :workerid, :insdate, :sts, :bkbikou)
    end
end
