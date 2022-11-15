# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 著者等追加
      #
      # PersonではなくWorkPersonへの追加なのに注意
      class AddPerson < Base
        def execute(command)
          work_id, person_id, role_name = command.body

          work = find_work!(work_id)
          person = find_person!(person_id)
          role = find_role_by_name!(role_name)

          work_person = WorkPerson.create!(work_id: work.id,
                                           person_id: person.id,
                                           role_id: role.id)

          Result.new(executed: true, command_result: work_person)
        end
      end
    end
  end
end
