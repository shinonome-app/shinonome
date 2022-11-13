# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報削除
      class DeleteBibclass < Base
        def execute(work_id, name, num)
          work = find_work!(work_id)

          Bibclass.where(work_id: work.id, name: name, num: num).destroy_all

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
