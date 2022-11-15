# frozen_string_literal: true

module Admin
  class ExecCommandsController < Admin::ApplicationController
    # GET /admin/exec_commands
    def index
      @exec_commands = Shinonome::ExecCommand.all
    end

    # GET /admin/exec_commands/new
    def new
      @exec_command = Shinonome::ExecCommand.new

      case params[:prev]
      when 'failed'
        @error_exec_command = Shinonome::ExecCommand.last
      when 'ok'
        @last_exec_command = Shinonome::ExecCommand.last
      end
    end

    # POST /admin/exec_commands
    def create
      @exec_command = Shinonome::ExecCommand.new(exec_command_params)
      @exec_command.user = current_admin_user
      unless @exec_command.save
        render :new, status: :unprocessable_entity
        return
      end

      unless @exec_command.execute
        redirect_to new_admin_exec_command_path(prev: :failed)
        return
      end

      redirect_to new_admin_exec_command_path(prev: :ok)
    end

    private

    # Only allow a list of trusted parameters through.
    def exec_command_params
      params.require(:shinonome_exec_command).permit(:command, :separator)
    end
  end
end
