# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報削除
      class DeleteBibclass < Base
        def execute(work_id, name, num)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          Bibclass.where(work_id: work_id, name: name, num: num).destroy_all

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
