# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報登録
      class AddBibclass < Base
        def execute(command)
          work_id, name, num, note = command.body
          _work = find_work!(work_id)

          bibclass = Bibclass.create!(work_id: work_id,
                                      name: name,
                                      num: num,
                                      note: note)

          Result.new(executed: true, command_result: bibclass)
        end
      end
    end
  end
end
