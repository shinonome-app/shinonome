# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # SQL実行。与えられたSQLをそのまま実行する
      # （DB構造が変わっているため旧システムと同じSQLが通らないのは仕様）
      class CommandSql < Base
        def execute(command)
          sql = command.body[0]
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.sql_blank') if sql.blank?

          ActiveRecord::Base.connection.execute(sql)

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
