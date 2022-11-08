# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 工作員関連づけ取得
      class GetWorkWorker < Base
        def execute(output_dir:)
          filename = 'book_worker.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_work_worker(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_work_worker(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(WorkWorker.csv_header)

          WorkWorker.order(:work_id, :id).each do |work_worker|
            io.write(work_worker.to_csv)
          end
        end
      end
    end
  end
end
