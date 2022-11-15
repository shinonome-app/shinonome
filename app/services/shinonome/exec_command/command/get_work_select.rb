# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品情報絞り込み
      class GetWorkSelect < Base
        def execute(command, output_dir:)
          columns_string = command.body.first
          columns = CSV.parse_line(columns_string)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_column') unless columns[0] == 'bookid'

          columns.each do |column|
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.columns_invalid') if column =~ /[^A-Za-z0-9_\p{Hiragana}一-龠々-]/
          end

          filename = 'bookselect.csv'
          output_file = File.join(output_dir, filename)

          File.open(output_file, 'wb') do |f|
            write_get_work_select(columns, f)
          end

          Result.new(executed: true, command_result: output_file)
        end

        def write_get_work_select(columns, io)
          io.write(Shinonome::ExecCommand::BOM)
          csv_header = CSV.generate_line(columns, force_quotes: false, row_sep: "\r\n")
          io.write(csv_header)

          Work.includes(:kana_type).includes(:work_status).includes(:user).find_each do |work|
            array = columns.map { |column| column_name2value(column, work) }
            csv_string = CSV.generate_line(array, force_quotes: true, row_sep: "\r\n")
            io.write(csv_string)
          end
        end

        def column_name2value(column_name, work)
          case column_name
          when 'bookid'
            work.id
          when '作品名'
            work.title
          when '作品名読み'
            work.title_kana
          when '副題'
            work.subtitle
          when '副題読み'
            work.subtitle_kana
          when '作品集名'
            work.collection
          when '作品集名読み'
            work.collection_kana
          when '原題'
            work.original_title
          when '仮名遣い種別'
            work.kana_type.name
          when '初出'
            work.first_appearance
          when '作品について'
            work.description
          when '状態'
            work.work_status.name
          when '状態の開始日'
            work.started_on.to_s
          when '著作権フラグ'
            work.copyright_char
          when '備考'
            work.note
          when '底本管理情報'
            work.orig_text
          when '最終更新日'
            work.updated_at.to_s
          when '更新者'
            work.user.user_name
          when 'ソート用読み'
            work.sortkey
          else
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.columns_invalid')
          end
        end
      end
    end
  end
end
