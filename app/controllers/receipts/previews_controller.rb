# frozen_string_literal: true

module Receipts
  # 入力受付プレビュー用
  class PreviewsController < ApplicationController
    # POST /receipts/previews
    def create
      @receipt_form = ReceiptForm.new(receipt_params)

      if @receipt_form.valid?
        render :show
      else
        render 'receipts/new'
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def receipt_params
      params.require(:receipt_form).permit(*ReceiptForm::PERMITTED_PARAMS)
    end
  end
end
