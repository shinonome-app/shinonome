# frozen_string_literal: true

require 'csv'

module Shinonome
  class ExecCommand
    class Command
      # @abstract
      # コマンド実行用の基本クラス。このクラスを継承する
      class Base
        # コマンド実行結果結果返却用
        class Result
          attr_reader :command_result

          def initialize(executed:, command_result:)
            @executed = executed
            @command_result = command_result
          end

          def successful?
            @executed
          end

          def failed?
            !@executed
          end
        end
      end
    end
  end
end
