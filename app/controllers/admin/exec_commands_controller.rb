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
      @last_exec_command = Shinonome::ExecCommand.last
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
        @error_messages = @exec_command.error_messages
        render :new, status: :unprocessable_entity
        return
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def exec_command_params
      params.require(:shinonome_exec_command).permit(:command, :separator)
    end
  end
end
