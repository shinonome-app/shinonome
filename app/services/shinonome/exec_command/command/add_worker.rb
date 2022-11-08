# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 工作員追加
      #
      # WorkerではなくWorkWorkerへの追加なのに注意
      class AddWorker < Base
        def execute(work_id, worker_id, role_name)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.worker_id_numeric') unless worker_id.to_s.match?(/\A[1-9]\d*\z/)

          worker_roles = WorkerRole.order(:id).pluck(:name)
          worker_role = WorkerRole.where(name: role_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.worker_role_invalid', worker_roles: %("#{worker_roles.join('"か"')}")) unless worker_role

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          work_worker = WorkWorker.create!(work_id: work_id,
                                           worker_id: worker_id,
                                           worker_role_id: worker_role.id)

          Result.new(executed: true, command_result: work_worker)
        end
      end
    end
  end
end
