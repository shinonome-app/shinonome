class ReceiptsController < ApplicationController
  # GET /receipts/new
  def new
    @receipt = Receipt.new
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

  private

  # Only allow a list of trusted parameters through.
  def receipt_params
    params.require(:receipt).permit(:sakuhinmeiyomi, :sakuhinmei, :fukudaiyomi, :fukudai, :sakuhinshuumeiyomi,
                                    :sakuhinshuumei, :gendai, :kana, :shoshutu, :memo, :bikou, :status, :statusdate, :copyright, :seiyomi, :sei, :seieiji, :meiyomi, :mei, :meieiji, :jbikou, :seimeiyomi, :seimei, :email, :url, :bookname, :publisher, :firstversion, :versioninput, :bookname2, :publisher2, :firstversion2, :personid, :workerid, :insdate, :sts, :bkbikou)
  end
end
