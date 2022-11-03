# frozen_string_literal: true

module Shinonome
  class ExecCommand
    # parse結果のコマンド列の実行
    class CommandExecutor
      def execute(command_text, format: :tsv)
        command_parser = Shinonome::ExecCommand::CommandParser.new
        commands = command_parser.parse(command_text, format: format)

        commands.each do |command|
          command.execute
        end
      end
    end
  end
end
