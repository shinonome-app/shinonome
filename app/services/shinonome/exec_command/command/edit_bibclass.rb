# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報更新
      class EditBibclass < Base
        def execute(command)
          work_id, name, num, note = command.body

          work = find_work!(work_id)

          note = '' if note == 'null'

          Bibclass.where(work_id: work.id, name: name, num: num).find_each { |bibclass| bibclass.update!(note: note, updated_at: Time.zone.now) }

          bibclasses = Bibclass.where(work_id: work.id, name: name, num: num)

          Result.new(executed: true, command_result: bibclasses)
        end
      end
    end
  end
end
