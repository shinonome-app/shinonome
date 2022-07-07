# frozen_string_literal: true

module Admin
  module Receipts
    # 入力受付一括削除用
    class BulkRemovesController < ApplicationController
      # POST /admin/receipts/bulk_removes
      def create
        @receipts = Receipt.active.ordered
        if @receipts.empty?
          redirect_to admin_receipts_path, notice: '削除対象の申込みはありませんでした'
          return
        end

        begin
          # @receipts.destroy!
          deleted_time = Time.zone.now
          @receipts.update(deleted_at: deleted_time, updated_at: deleted_time)
          redirect_to admin_receipts_path, notice: '一括削除しました'
        rescue StandardError
          redirect_to admin_receipts_path, notice: '削除に失敗しました'
        end
      end
    end
  end
end
