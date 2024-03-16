# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル追加
      class AddFile < Base
        def execute(command, upload_dir:)
          work_id,
          filetype_name,
          compresstype_name,
          url,
          create_date,
          update_date,
          revision_count,
          file_encoding_name,
          charset_name,
          note,
          filename = command.body

          work = find_work!(work_id)

          filetype = find_filetype_by_name!(filetype_name)
          compresstype = find_compresstype_by_name!(compresstype_name)
          file_encoding = find_file_encoding_by_name!(file_encoding_name)
          charset = find_charset_by_name!(charset_name)

          if url.blank?
            if filename.blank?
              raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filename_url_blank')
            elsif !File.exist?(File.join(upload_dir, filename))
              raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_not_uploaded')
            end
          end

          workfile = Workfile.create!(work_id: work.id,
                                      filetype_id: filetype.id,
                                      compresstype_id: compresstype.id,
                                      filesize: 0,
                                      url: url,
                                      created_at: create_date,
                                      updated_at: update_date,
                                      revision_count: revision_count,
                                      file_encoding_id: file_encoding.id,
                                      charset_id: charset.id,
                                      filename: filename,
                                      workfile_secret_attributes: { memo: note }
                                     )

          if url.blank?
            new_filename = workfile.generate_filename

            file_path = File.join(upload_dir, filename)
            new_file_path = File.join(upload_dir, new_filename)
            move_file(file_path, new_file_path)

            new_filesize = File.size(new_file_path)

            workfile.update!(filename: new_filename, filesize: new_filesize)
          end

          Result.new(executed: true, command_result: workfile)
        end
      end
    end
  end
end
