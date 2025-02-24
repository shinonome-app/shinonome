# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 耕作員追加
      #
      # WorkerではなくWorkWorkerへの追加なのに注意
      class AddWorker < Base
        def execute(command)
          work_id, worker_id, role_name = command.body

          work = find_work!(work_id)
          worker = find_worker!(worker_id)
          worker_role = find_worker_role_by_name!(role_name)

          work_worker = WorkWorker.create!(work_id: work.id,
                                           worker_id: worker.id,
                                           worker_role_id: worker_role.id)

          Result.new(executed: true, command_result: work_worker)
        end
      end
    end
  end
end
