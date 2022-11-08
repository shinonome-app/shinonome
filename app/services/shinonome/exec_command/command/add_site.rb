# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 関連サイト追加
      #
      # SiteではなくWorkSiteへの追加なのに注意
      class AddSite < Base
        def execute(work_id, site_id)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.site_id_numeric') unless site_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          begin
            _site = Site.find(site_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.site_not_found', site_id: site_id)
          end

          work_site = WorkSite.create!(work_id: work_id,
                                       site_id: site_id)

          Result.new(executed: true, command_result: work_site)
        end
      end
    end
  end
end
