# frozen_string_literal: true

class ReceiptsController < ApplicationController
  skip_forgery_protection only: %i[new_add_work new_remove_work]

  # GET /receipts
  def index
    redirect_to new_receipt_path
  end

  # GET /receipts/new
  def new
    @receipt_form = ReceiptForm.new
    @receipt_form.add_work
  end

  def new_add_work
    @receipt_form = ReceiptForm.new(receipt_params)
    @receipt_form.add_work

    render :new
  end

  def new_remove_work
    @receipt_form = ReceiptForm.new(receipt_params)
    @receipt_form.remove_work(params[:work_num])

    render :new
  end

  # POST /receipts
  def create
    if params[:edit]
      @receipt_form = ReceiptForm.new(receipt_params)
      render :new
      return
    end

    result = ReceiptsCreator.new.create_receipt(receipt_params)
    @receipt_form = result.receipt_form
    if result.created?
      redirect_to receipts_thanks_path
    else
      render :new
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
