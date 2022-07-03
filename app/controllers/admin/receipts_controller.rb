# frozen_string_literal: true

module Admin
  # Web入力受付管理
  class ReceiptsController < Admin::ApplicationController
    before_action :set_receipt, only: %i[show edit update destroy]

    # GET /admin/receipts
    def index
      @receipts = Receipt.all.order(id: :desc)
    end

    # GET /admin/receipts/1
    def show; end

    # GET /admin/receipts/1/edit
    def edit; end

    # PATCH/PUT /admin/receipts/1
    def update
      if @receipt.update(receipt_params)
        redirect_to [:admin, @receipt], notice: '更新しました.'
      else
        render 'admin/receipts/edit', status: :unprocessable_entity
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/receipts/1
    def destroy
      @receipt.destroy
      redirect_to admin_receipts_url, notice: '削除しました.'
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
                                      :updated_at, :user_id, :sortkey)
    end
  end
end
