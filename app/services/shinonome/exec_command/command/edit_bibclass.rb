# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報更新
      class EditBibclass < Base
        def execute(work_id, name, num, note)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          note = '' if note == 'null'

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found')
          end

          bibclasses = Bibclass.where(work_id: work_id, name: name, num: num).update_all!(note: note, updated_at: Time.zone.now)

          Result.new(executed: true, command_result: bibclasses)
        end
      end
    end
  end
end
