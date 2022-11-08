# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル追加
      class AddFile < Base
        # rubocop:disable Metrics/ParameterLists
        def execute(
          work_id:,
          filetype_name:,
          compresstype_name:,
          url:,
          create_date:,
          update_date:,
          revision_count:,
          file_encoding_name:,
          charset_name:,
          note:,
          filename:,
          upload_dir:
        )
          # rubocop:enable Metrics/ParameterLists
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          filetypes = Filetype.order(:id).pluck(:name)
          filetype = Filetype.where(id: filetype_name).first || Filetype.where(name: filetype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_invalid', filetypes: %("#{filetypes.join('"か"')}")) unless filetype

          compresstypes = Compresstype.order(:id).pluck(:name)
          compresstype = Compresstype.where(id: compresstype_name).first || Compresstype.where(name: compresstype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.compresstype_invalid', compresstypes: %("#{compresstypes.join('"か"')}")) unless compresstype

          file_encodings = FileEncoding.order(:id).pluck(:name)
          file_encoding = FileEncoding.where(id: file_encoding_name).first || FileEncoding.where(name: file_encoding_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_encoding_invalid', file_encodings: %("#{file_encodings.join('"か"')}")) unless file_encoding

          charsets = Charset.order(:id).pluck(:name)
          charset = Charset.where(id: charset_name).first || Charset.where(name: charset_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.charset_invalid', charsets: %("#{charsets.join('"か"')}")) unless charset

          begin
            work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          if url.blank?
            if filename.blank? # rubocop:disable Style/GuardClause
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
                                      note: note,
                                      filename: filename)

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

        def move_file(file_path, new_file_path)
          File.rename(file_path, new_file_path)
          File.chmod(0o666, new_file_path)
        end
      end
    end
  end
end
