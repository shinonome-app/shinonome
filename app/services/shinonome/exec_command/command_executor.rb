# frozen_string_literal: true

module Shinonome
  class ExecCommand
    # parse結果のコマンド列の実行
    class CommandExecutor
      def execute(exec_command, output_dir:, upload_dir:, format: :tsv)
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
        result = nil

        # コマンド列全体を1つのトランザクションで実行し、
        # 途中で1件でも失敗したら全コマンドのDB変更をロールバックする。
        # （ファイルシステムへの反映は各コマンドが after_all_transactions_commit で
        #  登録するため、コミット成功時のみ実行され、ロールバック時は破棄される）
        ActiveRecord::Base.transaction(requires_new: true) do
          commands.each_with_index do |command, idx|
            begin
              command_results << command.execute(output_dir:, upload_dir:)
            rescue StandardError => e
              errors << { error: e, index: idx, command: }
            end

            next if errors.empty?

            result = Result.new(executed: false, command_results:, errors:)
            raise ActiveRecord::Rollback
          end

          result = Result.new(executed: true, command_results:)
        end

        result
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
