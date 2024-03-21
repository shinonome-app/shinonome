# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報削除
      class DeleteBibclass < Base
        def execute(command)
          work_id, name, num = command.body

          work = find_work!(work_id)

          Bibclass.where(work_id: work.id, name:, num:).destroy_all

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
