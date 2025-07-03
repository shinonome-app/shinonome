# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # ファイル取得コマンド
      class GetFile < Base
        def execute(command, output_dir:)
          work_id, filetype_name, compresstype_name, workfile_id = command.body

          work = find_work!(work_id)

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_compresstype_file_id_blank') if (filetype_name.blank? || compresstype_name.blank?) && workfile_id.blank?

          filetype = find_filetype_by_name!(filetype_name) if filetype_name.present?
          compresstype = find_compresstype_by_name!(compresstype_name) if compresstype_name.present?

          workfile = if workfile_id.present?
                       find_workfile!(workfile_id)
                     else
                       Workfile.where('work_id = ? AND filetype_id = ? AND compresstype_id = ?', work.id, filetype.id, compresstype.id).order(updated_at: :desc).first or raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_not_found')
                     end

          output_file = File.join(output_dir, workfile.filename)

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_not_found') unless workfile.filesystem.exists?

          # filesystemから読み込み
          File.binwrite(output_file, workfile.filesystem.read)

          Result.new(executed: true, command_result: output_file)
        end
      end
    end
  end
end
