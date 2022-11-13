# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 関連サイト削除
      class DeleteSite < Base
        def execute(work_id, site_id)
          work = find_work!(work_id)
          site = find_site!(site_id)

          WorkSite.where(work_id: work.id, site_id: site.id).destroy_all!

          Result.new(executed: true, command_result: nil)
        end
      end
    end
  end
end
