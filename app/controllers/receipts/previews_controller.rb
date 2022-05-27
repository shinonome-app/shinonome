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
      params.require(:receipt_form).permit(
        :last_name_kana, :last_name, :last_name_en, :first_name_kana, :first_name, :first_name_en, :person_note,
        :worker_kana, :worker_name, :email, :url,
        :original_book_title, :publisher, :first_pubdate, :input_edition,
        :original_book_title2, :publisher2, :first_pubdate2,
        :person_id, :worker_id, :register_status, :original_book_note,
        sub_works_attributes: %i[
        title_kana
        title
        subtitle_kana
        subtitle
        original_title
        kana_type_id
        first_appearance
        memo
        note
        copyright_flag
      ]
      )
    end
  end
end
