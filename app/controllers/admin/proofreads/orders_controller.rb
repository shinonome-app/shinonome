# frozen_string_literal: true

module Admin
  module Proofreads
    # 校正受付発注
    class OrdersController < ApplicationController
      def new
        @proofread = Proofread.find(params[:id])
        @worker = @proofread.worker
        @worker_secret = @worker.worker_secret
        @work = @proofread.work

        @order_form = ::Admin::Proofreads::OrderForm.new
      end

      def create
        @proofread = Proofread.find(params[:id])
        @order_form = ::Admin::Proofreads::OrderForm.new(order_params, proofread: @proofread)
        @order_form.send!

        redirect_to admin_proofreads_path, success: '送信しました.'
      end

      private

      def order_params
        params.require(:proofread).permit(:mail_memo, :work_id)
      end
    end
  end
end
