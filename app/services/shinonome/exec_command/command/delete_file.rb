# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル削除
      class DeleteFile < Base
        def execute(command)
          work_id, filetype_name, compresstype_name, workfile_id = command.body

          work = find_work!(work_id)

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_compresstype_file_id_blank') if (filetype_name.blank? || compresstype_name.blank?) && workfile_id.blank?

          filetype = find_filetype_by_name!(filetype_name) if filetype_name.present?
          compresstype = find_compresstype_by_name!(compresstype_name) if compresstype_name.present?

          workfile = if workfile_id.present?
                       find_workfile!(workfile_id)
                     else
                       Workfile.where(work_id: work.id, filetype_id: filetype.id, compresstype_id: compresstype.id).first
                     end

          # 実ファイルシステム上のパスを削除前に確定させる
          remove_path = workfile.url.blank? ? workfile.filesystem.path : nil

          workfile.destroy!

          # 物理ファイルの削除はコミット成功後に行う
          # （バッチが途中で失敗した場合はロールバックされ、ファイルは削除されない）
          if remove_path
            ActiveRecord.after_all_transactions_commit do
              FileUtils.rm_f(remove_path)
            end
          end

          Result.new(executed: true, command_result: remove_path&.to_s)
        end
      end
    end
  end
end
