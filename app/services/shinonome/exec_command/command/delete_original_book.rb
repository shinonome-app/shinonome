# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本削除
      class DeleteOriginalBook < Base
        def execute(work_id, name, publisher)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          OriginalBook.where(work_id: work_id, name: name, publisher: publisher).destroy_all!

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
