# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 工作員取得
      class GetWorker < Base
        def execute(_command, output_dir:)
          filename = 'worker.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_worker(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_worker(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Worker.csv_header)

          Worker.order(:id).each do |worker|
            next if worker.id == 0

            io.write(worker.to_csv)
          end
        end
      end
    end
  end
end
