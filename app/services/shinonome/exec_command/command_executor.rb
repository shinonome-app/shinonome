# frozen_string_literal: true

module Shinonome
  class ExecCommand
    # parse結果のコマンド列の実行
    class CommandExecutor
      def execute(exec_command, output_dir:, format: :tsv)
        command_text = exec_command.command
        command_parser = Shinonome::ExecCommand::CommandParser.new
        errors = []

        begin
          commands = command_parser.parse(command_text, format: format)
        rescue StandardError => error
          errors << {error: error, index: 0, command: nil}
          return Result.new(executed: false, errors: errors)
        end

        command_results = []
        commands.each_with_index do |command, idx|
          begin
            command_result = command.execute(output_dir: output_dir)
            command_results << command_result
          rescue StandardError => error
            errors << {error: error, index: idx, command: command}
          end

          # TODO: should be ignore some errors in the loop
          if errors.present?
            return Result.new(executed: false, command_results: command_results, errors: errors)
          end
        end

        if errors.empty?
          Result.new(executed: true, command_results: command_results)
        else
          # TODO: never reached
          Result.new(executed: false, command_results: command_results, errors: errors)
        end
      end

      # 結果返却用
      class Result
        attr_reader :errors, :command_results

        def initialize(executed:, command_results: nil, errors: nil)
          @executed = executed
          @errors = errors
          @command_results = command_results
        end

        def executed?
          @executed
        end

        def successful?
          @executed
        end
      end
    end
  end
end
