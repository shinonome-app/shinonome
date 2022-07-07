# frozen_string_literal: true

module Admin
  module Proofreads
    # 校正受付一括削除用
    class BulkRemovesController < ApplicationController
      # POST /admin/proofreads/bulk_removes
      def create
        @proofreads = Proofread.active.ordered
        if @proofreads.empty?
          redirect_to admin_proofreads_path, notice: '削除対象の申込みはありませんでした'
          return
        end

        begin
          # @proofreads.destroy!
          deleted_time = Time.zone.now
          @proofreads.update(deleted_at: deleted_time, updated_at: deleted_time)
          redirect_to admin_proofreads_path, notice: '一括削除しました'
        rescue StandardError
          redirect_to admin_proofreads_path, notice: '削除に失敗しました'
        end
      end
    end
  end
end
