# frozen_string_literal: true

module Proofreads
  # 校正受付プレビュー用
  class PreviewsController < ApplicationController
    # POST /proofreads/previews
    def create
      @receipt = Receipt.new(receipt_params)

      if @receipt.valid?
        render :show
      else
        render :new
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def receipt_params
      params.require(:receipt).permit(:title_kana, :title, :subtitle_kana, :subtitle, :collection_kana,
                                      :collection, :original_title,
                                      :kana_type_id, :first_appearance, :memo, :note, :status, :started_on, :copyright_flag,
                                      :last_name_kana, :last_name, :last_name_en, :first_name_kana, :first_name, :first_name_en, :person_note,
                                      :worker_kana, :worker_name, :email, :url,
                                      :original_book_title, :publisher, :first_pubdate, :input_edition, :original_book_title2, :publisher2, :first_pubdate2,
                                      :person_id, :worker_id, :created_on, :register_status, :original_book_note)
    end
  end
end
