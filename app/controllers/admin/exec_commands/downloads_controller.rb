# frozen_string_literal: true

module Admin
  module ExecCommands
    class DownloadsController < Admin::ApplicationController
      before_action :set_exec_command

      # GET /admin/exec_commands/:exec_command_id/download
      def show
        if @exec_command.file_exists?
          send_file @exec_command.filesystem.path,
                    filename: 'result.zip',
                    type: 'application/zip',
                    disposition: 'attachment'
        else
          redirect_to admin_exec_commands_path, alert: 'ファイルが見つかりません。'
        end
      end

      private

      def set_exec_command
        @exec_command = Shinonome::ExecCommand.find(params[:exec_command_id])
      end
    end
  end
end
