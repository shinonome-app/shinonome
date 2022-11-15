# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品情報取得コマンド
      class GetWork < Base
        def execute(_command, output_dir:)
          filename = 'book.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_work(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_work(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Work.csv_header)

          Work.includes(:kana_type).includes(:work_status).includes(:user).find_each do |work|
            io.write(work.to_csv)
          end
        end
      end
    end
  end
end
