# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 耕作員削除
      class DeleteWorker < Base
        def execute(command)
          work_id, worker_id = command.body

          work = find_work!(work_id)
          worker = find_worker!(worker_id)

          WorkPerson.where(work_id: work.id, worker_id: worker.id).destroy_all!

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
