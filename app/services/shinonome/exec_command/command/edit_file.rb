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

          _work = find_work!(work_id)

          filetype = find_filetype_by_name!(filetype_name)
          compresstype = find_compresstype_by_name!(compresstype_name)
          file_encoding = find_file_encoding_by_name!(file_encoding_name)
          charset = find_charset_by_name!(charset_name)
          workfile = find_workfile!(workfile_id) if workfile_id.present?

          workfile ||= Workfile.where(work_id: work_id, filetype_id: filetype.id, compresstype_id: compresstype.id).first

          # ファイルの削除
          remove_filename = File.join(upload_dir, workfile.filename) if workfile.url.blank? && (filename.present? || (url.present? && url != 'null'))

          revision_count = workfile.revision_count + 1 if revision_count.blank?

          update_values = {}

          if (url.blank? || url == 'null') && filename.present?
            # ファイルアップロードの場合、そのファイルからファイルサイズを求める
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_not_uploaded') unless File.exist?(File.join(upload_dir, filename))

            new_filename = workfile.generate_filename

            file_path = File.join(upload_dir, filename)
            new_file_path = File.join(upload_dir, new_filename)
            move_file(file_path, new_file_path)

            new_filesize = File.size(new_file_path)

            workfile.update!(filename: new_filename, filesize: new_filesize)
            update_values.merge!(filename: new_filename, filesize: new_filesize)
          elsif url.present? && url != 'null'
            # URLで与えられた場合、ファイル名とファイルサイズは空にする
            update_values.merge!(filename: nil, filesize: 0)
          elsif filename != 'null'
            # ファイル名とファイルサイズは与えられたものを使う
            update_values.merge!(filename: workfile.filename, filesize: workfile.filesize)
          else # rubocop:disable Lint/DuplicateBranch
            # ファイル名がnullの場合??
            update_values.merge!(filename: nil, filesize: 0)
          end

          if note.present?
            update_values[:note] = note == 'null' ? '' : note
          end
          if url.present?
            update_values[:url] = url == 'null' ? '' : url
          end
          if create_date.present?
            update_values[:created_at] = create_date == 'null' ? '' : create_date
          end

          update_values[:revision_count] = revision_count == 'null' ? 0 : revision_count
          update_values[:updated_at] = update_date.presence || Time.zone.now
          update_values[:file_encoding_id] = file_encoding.id if file_encoding
          update_values[:charset_id] = charset.id if charset

          workfile.update!(**update_values)

          Result.new(executed: true, command_result: remove_filename)
        end
        # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      end
    end
  end
end
