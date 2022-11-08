# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 著者等追加
      #
      # PersonではなくWorkPersonへの追加なのに注意
      class AddPerson < Base
        def execute(work_id, person_id, role_name)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.person_id_numeric') unless person_id.to_s.match?(/\A[1-9]\d*\z/)

          roles = Role.order(:id).pluck(:name)
          role = Role.where(name: role_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.role_not_found', roles: %("#{roles.join('"か"')}")) unless role

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          work_person = WorkPerson.create!(work_id: work_id,
                                           person_id: person_id,
                                           role_id: role.id)

          Result.new(executed: true, command_result: work_person)
        end
      end
    end
  end
end
