# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 耕作員削除
      class DeleteWorker < Base
        def execute(command)
          work_id, worker_id, role_name = command.body

          work = find_work!(work_id)
          worker = find_worker!(worker_id)
          worker_role = find_worker_role_by_name!(role_name)

          work_workers = WorkWorker.where(work_id: work.id, worker_id: worker.id, worker_role_id: worker_role.id)
          raise ActiveRecord::RecordNotFound if work_workers.empty?

          work_workers.destroy_all

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
