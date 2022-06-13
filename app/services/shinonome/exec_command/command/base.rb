# frozen_string_literal: true

require 'csv'

module Shinonome
  class ExecCommand
    class Command
      # @abstract
      # コマンド実行用の基本クラス。このクラスを継承する
      class Base
        def self.execute(exec_command, params)
          new.execute(exec_command, params)
        end
      end
    end
  end
end
