# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 関連サイト追加
      #
      # SiteではなくWorkSiteへの追加なのに注意
      class AddSite < Base
        def execute(command)
          work_id, site_id = command.body

          work = find_work!(work_id)
          site = find_site!(site_id)

          work_site = WorkSite.create!(work_id: work.id,
                                       site_id: site.id)

          Result.new(executed: true, command_result: work_site)
        end
      end
    end
  end
end
