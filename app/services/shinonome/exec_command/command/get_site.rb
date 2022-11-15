# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 'site'コマンドの実装クラス
      class GetSite < Base
        COLUMNS = %i[id name url owner_name email note updated_at updated_by].freeze
        FILENAME = 'work.csv'

        def execute(_command, output_dir:)
          filename = 'site.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_site(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_site(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Site.csv_header)

          Site.find_each do |site|
            io.write(site.to_csv)
          end
        end
      end
    end
  end
end
