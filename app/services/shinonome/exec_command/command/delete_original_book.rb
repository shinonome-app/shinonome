# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本削除
      class DeleteOriginalBook < Base
        def execute(work_id, name, publisher)
          work = find_work!(work_id)

          OriginalBook.where(work_id: work.id, name: name, publisher: publisher).destroy_all!

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
