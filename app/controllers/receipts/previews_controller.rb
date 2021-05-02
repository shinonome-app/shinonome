module Receipts
  # 入力受付プレビュー用
  class PreviewsController < ApplicationController
    # POST /receipts/previews
    def create
      @receipt = Receipt.new(receipt_params)

      if @receipt.valid?
        render :preview
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
end
