# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品関連サイト取得
      class GetWorkSite
        def execute(output_dir:)
          filename = 'book_site.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_work_site(f)
          end
        end

        def write_get_work_site(io)
          io.write(Shinonome::ExecCommand::BOM)
          io.write(Work.csv_header_with_site)

          Work.includes(:kana_type).includes(:work_status).includes(:user).includes(work_people: :role).includes(:people).includes(:work_sites).includes(:sites).find_each do |work|
            io.write(work.to_csv_with_site)
          end
        end
      end
    end
  end
end
