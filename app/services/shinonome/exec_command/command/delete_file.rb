# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル削除
      class DeleteFile < Base
        def execute(work_id, filetype_name, compresstype_name, workfile_id, upload_dir:)
          work = find_work!(work_id)

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_compresstype_file_id_blank') if (filetype_name.blank? || compresstype_name.blank?) && workfile_id.blank?

          filetype = find_filetype_by_name!(filetype_name) if filetype_name.present?
          compresstype = find_compresstype_by_name!(compresstype_name) if compresstype_name.present?

          workfile = if workfile_id.present?
                       find_workfile!(workfile_id)
                     else
                       Workfile.where(work_id: work.id, filetype_id: filetype.id, compresstype_id: compresstype.id).first
                     end

          # rubocop:disable Style/IfUnlessModifier
          remove_filename = if workfile.url.blank?
                              File.join(upload_dir, workfile.filename)
                            end
          # rubocop:enable Style/IfUnlessModifier

          workfile.destroy!

          Result.new(executed: true, command_result: remove_filename)
        end
      end
    end
  end
end
