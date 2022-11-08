# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 関連サイト削除
      class DeleteSite < Base
        def execute(work_id, site_id)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.site_id_numeric') unless site_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          WorkSite.where(work_id: work_id, site_id: site_id).destroy_all!

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
