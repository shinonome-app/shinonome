# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 著者情報取得
      class GetPerson < Base
        def execute(_command, output_dir:)
          filename = 'person.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_person(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_person(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Person.csv_header)

          Person.find_each do |person|
            # skip '著者なし' data
            next if person.id == 0

            io.write(person.to_csv)
          end
        end
      end
    end
  end
end
