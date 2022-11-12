# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル更新
      class EditFile < Base
        # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
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
          workfile_id:,
          upload_dir:
        )
          # rubocop:enable Metrics/ParameterLists

          validate_work_id(work_id)

          filetype = validate_filetype(filetype_name)
          compresstype = validate_compresstype(compresstype_name)
          file_encoding = validate_file_encoding(file_encoding_name)
          charset = validate_charset(charset_name)
          workfile = validate_workfile_id(workfile_id)

          workfile ||= Workfile.where(work_id: work_id, filetype_id: filetype.id, compresstype_id: compresstype.id).first

          # ファイルの削除
          remove_filename = File.join(upload_dir, workfile.filename) if workfile.url.blank? && (filename.present? || (url.present? && url != 'null'))

          revision_count = workfile.revision_count + 1 if revision_count.blank?

          update_params = {}

          if (url.blank? || url == 'null') && filename.present?
            # ファイルアップロードの場合、そのファイルからファイルサイズを求める
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_not_uploaded') unless File.exist?(File.join(upload_dir, filename))

            new_filename = workfile.generate_filename

            file_path = File.join(upload_dir, filename)
            new_file_path = File.join(upload_dir, new_filename)
            move_file(file_path, new_file_path)

            new_filesize = File.size(new_file_path)

            workfile.update!(filename: new_filename, filesize: new_filesize)
            update_params.merge!(filename: new_filename, filesize: new_filesize)
          elsif url.present? && url != 'null'
            # URLで与えられた場合、ファイル名とファイルサイズは空にする
            update_params.merge!(filename: nil, filesize: 0)
          elsif filename != 'null'
            # ファイル名とファイルサイズは与えられたものを使う
            update_params.merge!(filename: workfile.filename, filesize: workfile.filesize)
          else # rubocop:disable Lint/DuplicateBranch
            # ファイル名がnullの場合??
            update_params.merge!(filename: nil, filesize: 0)
          end

          if note.present?
            update_params[:note] = note == 'null' ? '' : note
          end
          if url.present?
            update_params[:url] = url == 'null' ? '' : url
          end
          if create_date.present?
            update_params[:created_at] = create_date == 'null' ? '' : create_date
          end

          update_params[:revision_count] = revision_count == 'null' ? 0 : revision_count
          update_params[:updated_at] = update_date.presence || Time.zone.now
          update_params[:file_encoding_id] = file_encoding.id if file_encoding
          update_params[:charset_id] = charset.id if charset

          workfile.update!(**update_params)

          Result.new(executed: true, command_result: remove_filename)
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

        def move_file(file_path, new_file_path)
          File.rename(file_path, new_file_path)
          File.chmod(0o666, new_file_path)
        end

        def validate_work_id(work_id)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end
        end

        def validate_filetype(filetype_name)
          return if filetype_name.blank?

          filetypes = Filetype.order(:id).pluck(:name)
          filetype = Filetype.where(id: filetype_name).first || Filetype.where(name: filetype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_invalid', filetypes: %("#{filetypes.join('"か"')}")) unless filetype

          filetype
        end

        def validate_compresstype(compresstype_name)
          return if compresstype_name.blank?

          compresstypes = Compresstype.order(:id).pluck(:name)
          compresstype = Compresstype.where(id: compresstype_name).first || Compresstype.where(name: compresstype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.compresstype_invalid', compresstypes: %("#{compresstypes.join('"か"')}")) unless compresstype

          compresstype
        end

        def validate_file_encoding(file_encoding_name)
          return if file_encoding_name.blank?

          file_encodings = FileEncoding.order(:id).pluck(:name)
          file_encoding = FileEncoding.where(id: file_encoding_name).first || FileEncoding.where(name: file_encoding_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_encoding_invalid', file_encodings: %("#{file_encodings.join('"か"')}")) unless file_encoding

          file_encoding
        end

        def validate_charset(charset_name)
          return if charset_name.blank?

          charsets = Charset.order(:id).pluck(:name)
          charset = Charset.where(id: charset_name).first || Charset.where(name: charset_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.charset_invalid', charsets: %("#{charsets.join('"か"')}")) unless charset

          charset
        end

        def validate_workfile_id(workfile_id)
          return if workfile_id.blank?

          Workfile.find(workfile_id)
        rescue ActiveRecord::RecordNotFound
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.workfile_not_found')
        end
      end
    end
  end
end
