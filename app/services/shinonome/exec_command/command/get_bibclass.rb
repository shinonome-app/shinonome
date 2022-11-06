# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 書誌情報取得
      class GetBibclass
        def execute(output_dir:)
          filename = 'bibclass.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_bibclass(f)
          end
        end

        def write_get_bibclass(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Bibclass.csv_header)

          Bibclass.order(:work_id).each do |bibclass|
            io.write(bibclass.to_csv)
          end
        end
      end
    end
  end
end
