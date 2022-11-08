# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本取得(source)
      class GetOriginalBook < Base
        def execute(output_dir:)
          filename = 'source.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_original_book(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_original_book(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(OriginalBook.csv_header)

          OriginalBook.order(:work_id, :id).each do |original_book|
            io.write(original_book.to_csv)
          end
        end
      end
    end
  end
end
