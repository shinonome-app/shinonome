# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 著者関連サイト取得
      class GetPersonSite < Base
        def execute(output_dir:)
          filename = 'person_site.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_person_site(f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_person_site(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(PersonSite.csv_header)

          PersonSite.find_each do |person_site|
            io.write(person_site.to_csv)
          end
        end
      end
    end
  end
end
