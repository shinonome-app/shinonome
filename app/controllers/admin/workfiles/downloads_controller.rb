# frozen_string_literal: true

module Admin
  module Workfiles
    class DownloadsController < Admin::ApplicationController
      before_action :set_workfile

      # GET /admin/works/:work_id/workfiles/:workfile_id/download
      def show
        if @workfile.file_exists?
          send_file @workfile.filesystem.path,
                    filename: @workfile.filename,
                    type: 'application/octet-stream',
                    disposition: 'attachment'
        else
          redirect_to admin_work_url(@workfile.work), alert: 'ファイルが見つかりません。'
        end
      end

      private

      def set_workfile
        @workfile = Workfile.find(params[:workfile_id])
      end
    end
  end
end
