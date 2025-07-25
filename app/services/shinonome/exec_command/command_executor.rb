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
          commands = command_parser.parse(command_text, format:)
        rescue StandardError => e
          errors << { error: e, index: 0, command: nil }
          return Result.new(executed: false, errors:)
        end

        command_results = []
        commands.each_with_index do |command, idx|
          begin
            command_result = if command.method(:execute).parameters.any? { |_type, name| name == :output_dir }
                               command.execute(output_dir:)
                             else
                               command.execute
                             end
            command_results << command_result
          rescue StandardError => e
            errors << { error: e, index: idx, command: }
          end

          # TODO: should be ignore some errors in the loop
          return Result.new(executed: false, command_results:, errors:) if errors.present?
        end

        if errors.empty?
          Result.new(executed: true, command_results:)
        else
          # TODO: never reached
          Result.new(executed: false, command_results:, errors:)
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
