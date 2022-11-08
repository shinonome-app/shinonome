# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品ファイル削除
      class DeleteFile < Base
        def execute(work_id, filetype_name, compresstype_name, workfile_id, upload_dir:)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_compresstype_file_id_blank') if (filetype_name.blank? || compresstype_name.blank?) && workfile_id.blank?

          filetypes = Filetype.order(:id).pluck(:name)
          filetype = Filetype.where(id: filetype_name).first || Filetype.where(name: filetype_name).first

          if filetype_name.present? && filetype.blank? # rubocop:disable Style/IfUnlessModifier
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_invalid', filetypes: %("#{filetypes.join('"か"')}"))
          end

          compresstypes = Compresstype.order(:id).pluck(:name)
          compresstype = Compresstype.where(id: compresstype_name).first || Compresstype.where(name: compresstype_name).first

          if compresstype_name.present? && compresstype.blank? # rubocop:disable Style/IfUnlessModifier
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.compresstype_invalid', compresstypes: %("#{compresstypes.join('"か"')}"))
          end

          workfile = if workfile_id.present?
                       begin
                         Workfile.find(workfile_id)
                       rescue ActiveRecord::RecordNotFound
                         raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.workfile_not_found')
                       end
                     else
                       Workfile.where(work_id: work_id, filetype_id: filetype.id, compresstype_id: compresstype.id).first
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
