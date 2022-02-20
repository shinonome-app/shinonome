# frozen_string_literal: true

module Admin
  class ExecCommandsController < Admin::ApplicationController
    DOWNLOAD_DIR = 'tmp/exec_command'

    # GET /admin/exec_commands
    def index
      @exec_commands = Shinonome::ExecCommand.all
    end

    # GET /admin/exec_commands/new
    def new
      @exec_command = Shinonome::ExecCommand.new
    end

    # POST /admin/exec_commands
    def create
      @exec_command = Shinonome::ExecCommand.new(exec_command_params)
      @exec_command.user = current_admin_user
      unless @exec_command.save
        render :new
        return
      end

      Dir.mkdir_p(Rails.root.join(DOWNLOAD_DIR))
      download_path = generate_donwload_path

      unless @exec_command.execute(download_path)
        render :new
        return
      end

      send_file download_path, type: 'application/zip'
    end

    private

    # Only allow a list of trusted parameters through.
    def exec_command_params
      params.require(:exec_command).permit(:command)
    end

    def generate_donwload_path
      Rails.root.join(DOWNLOAD_DIR, Time.zone.now.strftime('%Y%m%d-%H%m%S-%L'))
    end
  end
end
