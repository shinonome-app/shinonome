# frozen_string_literal: true

module Admin
  # Web入力受付管理
  class ReceiptsController < Admin::ApplicationController
    before_action :set_receipt, only: %i[show]

    # GET /admin/receipts
    def index
      @receipts = Receipt.includes(
        :kana_type
      ).active.order(id: :desc)
    end

    # GET /admin/receipts/1
    def show
      @receipt = Receipt.find(params[:id])
    end

    # GET /admin/receipts/1/edit
    def edit
      receipt = Receipt.find(params[:id])

      if receipt.ordered?
        redirect_to admin_receipt_path
        return
      end

      @receipt_form =
        if params[:receipt]
          ReceiptForm.new(receipt_params, receipt:)
        else
          ReceiptForm.new(receipt:)
        end

      if params[:receipt]
        @receipt_form.worker_name = params[:receipt][:worker_name]
        @receipt_form.worker_kana = params[:receipt][:worker_kana]
        @receipt_form.email = params[:receipt][:email]
        @receipt_form.url = params[:receipt][:url]
      end
      @worker, @worker_secret = @receipt_form.worker_and_worker_secret
    end

    # PATCH/PUT /admin/receipts/1
    def update
      receipt = Receipt.find(params[:id])

      if receipt.ordered?
        redirect_to edit_admin_receipt_path(receipt)
        return
      end

      @receipt_form = ReceiptForm.new(
        receipt_params,
        receipt:,
        current_admin_user:
      )
      if @receipt_form.save
        ReceiptOrderSender.new.send(receipt: @receipt_form.receipt)
        redirect_to [:admin, @receipt_form], success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render 'admin/receipts/edit', status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_receipt
      @receipt = Receipt.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def receipt_params
      params.require(:receipt).permit(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                      :original_title, :kana_type_id, :author_display_name, :first_appearance, :description,
                                      :description_person_id, :status, :started_on, :copyright_flag, :note, :orig_text,
                                      :updated_at, :user_id, :sortkey,
                                      :memo, :work_status_id,
                                      :last_name_kana, :last_name, :last_name_en,
                                      :first_name_kana, :first_name, :first_name_en,
                                      :person_note, :person_id,
                                      :worker_id, :worker_kana, :worker_name, :email, :url,
                                      :original_book_title, :publisher, :first_pubdate, :input_edition, :original_book_note,
                                      :original_book_title2, :publisher2, :first_pubdate2,
                                      :no_send_mail, :cc_flag)
    end
  end
end
