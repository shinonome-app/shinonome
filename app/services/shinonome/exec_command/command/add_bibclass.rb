# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報登録
      class AddBibclass < Base
        def execute(work_id, name, num, note)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

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
