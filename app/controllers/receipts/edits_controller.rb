# frozen_string_literal: true

module Receipts
  # 確認画面の「戻る」用。送られた内容で入力画面を表示し直す（保存はしない）
  class EditsController < ApplicationController
    # POST /receipts/edits
    def create
      @receipt_form = ReceiptForm.new(params.require(:receipt_form).permit(*ReceiptForm::PERMITTED_PARAMS))
      render 'receipts/new', status: :unprocessable_entity
    end
  end
end
