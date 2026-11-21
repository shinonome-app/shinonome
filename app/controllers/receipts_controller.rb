# frozen_string_literal: true

class ReceiptsController < ApplicationController
  include RateLimitedCreate

  skip_forgery_protection only: %i[new_add_work new_remove_work]

  # GET /receipts
  def index
    redirect_to new_receipt_path
  end

  # GET /receipts/new
  def new
    @receipt_form = ReceiptForm.new
    @receipt_form.add_work(ReceiptForm::SubWork.new)
  end

  def new_add_work
    @receipt_form = ReceiptForm.new(receipt_params)
    @receipt_form.add_work(ReceiptForm::SubWork.new)

    render :new, status: :unprocessable_entity
  end

  def new_remove_work
    @receipt_form = ReceiptForm.new(receipt_params)
    @receipt_form.remove_work_at(params[:work_num])

    render :new, status: :unprocessable_entity
  end

  # POST /receipts
  def create
    result = ReceiptsCreator.new.create_receipt(receipt_params)
    @receipt_form = result.receipt_form
    if result.created?
      redirect_to receipts_thanks_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def receipt_params
    params.require(:receipt_form).permit(*ReceiptForm::PERMITTED_PARAMS)
  end
end
