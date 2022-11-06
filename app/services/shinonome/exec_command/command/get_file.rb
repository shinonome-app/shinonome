# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # ファイル取得コマンド
      class GetFile
        def execute(work_id, filetype_id, compresstype_id, workfile_id, output_dir:)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.book_id_blank') if work_id.blank?

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.filetype_compresstype_file_id_blank') if (filetype_id.blank? || compresstype_id.blank?) && workfile_id.blank?

          if filetype_id.present?
            filetype = Filetype.where(id: filetype_id).first || Filetype.where(name: filetype_id).first
            if filetype.blank?
              valid_filetypes = %("#{Filetype.pluck(:name).all.join('", "')}")
              raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.filetype_invalid', valid_filetypes: valid_filetypes)
            end
          end

          if compresstype_id.present?
            compresstype = Compresstype.where(id: compresstype_id).first || Compresstype.where(name: compresstype_id).first
            if compresstype.blank?
              valid_compresstypes = %("#{Compresstype.pluck(:name).all.join('", "')}")
              raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.compresstype_invalid', valid_compresstypes: valid_compresstypes)
            end
          end

          workfile = if workfile_id.present?
                       begin
                         Workfile.find(workfile_id)
                       rescue StandardError
                         raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.file_by_id_not_found')
                       end
                     else
                       Workfile.where('work_id = ? AND filetype_id = ? AND compresstype_id = ?', work_id, filetype_id, compresstype_id).order(updated_at: :desc).first or raise Shinonome::ExecCommand::FormatError, I18n.t('errors.get_file.file_not_found')
                     end

          output_file = File.join(output_dir, workfile.filename)
          File.binwrite(output_file, workfile.workdata.download)
        end
      end
    end
  end
end
