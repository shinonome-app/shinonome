# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # book_personコマンド
      class GetWorkPerson
        def execute(output_dir:)
          filename = 'book_person.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_work_person(f)
          end
        end

        def write_get_work_person(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(WorkPerson.csv_header)

          WorkPerson.includes(:role).order(:work_id).each do |work_person|
            io.write(work_person.to_csv)
          end
        end
      end
    end
  end
end
