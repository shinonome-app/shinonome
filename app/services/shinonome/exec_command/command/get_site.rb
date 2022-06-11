# frozen_string_literal: true

module Shinonome
  class ExecCommand
    # 'site'コマンドの実装クラス
    class GetSite < ExecCommand::Base
      COLUMNS = %i[id name url owner_name email note updated_at updated_by].freeze
      FILENAME = 'work.csv'

      def exec(exec_command, _params)
        csv_data = CSV.generate do |csv|
          csv << COLUMNS.map { |col| I18n.t(col, scope: 'activerecord.attributes.site') }
          Site.order(:id).find_in_batches do |batch|
            batch.each do |site|
              csv << site.attributes.values_at(*COLUMNS)
            end
          end
        end

        csv_path = File.join(exec_command.csv_path, FILENAME)
        File.write(csv_path, csv_data)
      end
    end
  end
end
