# frozen_string_literal: true

module Shinonome
  class ExecCommand
    # parse結果のコマンド列の実行
    class CommandExecutor
      def execute(command_text, output_dir:, format: :tsv)
        command_parser = Shinonome::ExecCommand::CommandParser.new
        begin
          commands = command_parser.parse(command_text, format: format)
        rescue RuntimeError => e
          return Result.new(executed: false, error: e)
        end

        commands.each do |command|
          command_result = command.execute(output_dir: output_dir)
          return Result.new(executed: false, command_result: command_result) unless result.executed?
        end

        Result.new(executed: true)
      end

      # 結果返却用
      class Result
        attr_reader :error, :command_result

        def initialize(executed:, command_result: nil, error: nil)
          @executed = executed
          @error = error
          @command_result = command_result
        end

        def executed?
          @executed
        end
      end
    end
  end
end
