# frozen_string_literal: true

module Admin
  module Receipts
    # 入力受付プレビュー用
    class PreviewsController < ApplicationController
      # POST /admin/receipts/previews
      def update
        @receipt_form = ::Admin::ReceiptForm.new(receipt_params, receipt: Receipt.find(params[:id]))
        if @receipt_form.valid?
          render 'show'
        else
          render 'admin/receipts/edit', status: :unprocessable_entity
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def receipt_params
        params.require(:receipt).permit(
          :title, :title_kana, :subtitle, :subtitle_kana, :original_title,
          :kana_type_id,
          :first_appearance, :memo, :note,
          :last_name_kana, :last_name, :last_name_en, :first_name_kana, :first_name, :first_name_en, :person_note,
          :worker_kana, :worker_name, :email, :url,
          :original_book_title, :publisher, :first_pubdate, :input_edition,
          :original_book_title2, :publisher2, :first_pubdate2,
          :person_id, :worker_id, :register_status, :original_book_note,
          :work_status_id,
        )
      end
    end
  end
end
