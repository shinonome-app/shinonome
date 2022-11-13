# frozen_string_literal: true

require 'csv'

module Shinonome
  class ExecCommand
    class Command
      # @abstract
      # コマンド実行用の基本クラス。このクラスを継承する
      class Base
        # コマンド実行結果結果返却用
        class Result
          attr_reader :command_result

          def initialize(executed:, command_result:)
            @executed = executed
            @command_result = command_result
          end

          def successful?
            @executed
          end

          def failed?
            !@executed
          end
        end

        # Utility methods
        def move_file(file_path, new_file_path)
          File.rename(file_path, new_file_path)
          File.chmod(0o666, new_file_path)
        end

        def find_work!(work_id)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          Work.find(work_id)
        rescue ActiveRecord::RecordNotFound
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
        end

        def find_filetype_by_name!(filetype_name)
          return if filetype_name.blank?

          filetypes = Filetype.order(:id).pluck(:name)
          filetype = Filetype.where(id: filetype_name).first || Filetype.where(name: filetype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.filetype_invalid', filetypes: %("#{filetypes.join('"か"')}")) unless filetype

          filetype
        end

        def find_compresstype_by_name!(compresstype_name)
          return if compresstype_name.blank?

          compresstypes = Compresstype.order(:id).pluck(:name)
          compresstype = Compresstype.where(id: compresstype_name).first || Compresstype.where(name: compresstype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.compresstype_invalid', compresstypes: %("#{compresstypes.join('"か"')}")) unless compresstype

          compresstype
        end

        def find_file_encoding_by_name!(file_encoding_name)
          return if file_encoding_name.blank?

          file_encodings = FileEncoding.order(:id).pluck(:name)
          file_encoding = FileEncoding.where(id: file_encoding_name).first || FileEncoding.where(name: file_encoding_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.file_encoding_invalid', file_encodings: %("#{file_encodings.join('"か"')}")) unless file_encoding

          file_encoding
        end

        def find_kana_type_by_name!(kana_type_name)
          kana_types = KanaType.order(:id).pluck(:name)
          kana_type  = KanaType.where(name: kana_type_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.kana_type_invalid', kana_types: %("#{kana_types.join('"か"')}")) unless kana_type

          kana_type
        end

        def find_charset_by_name!(charset_name)
          return if charset_name.blank?

          charsets = Charset.order(:id).pluck(:name)
          charset = Charset.where(id: charset_name).first || Charset.where(name: charset_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.charset_invalid', charsets: %("#{charsets.join('"か"')}")) unless charset

          charset
        end

        def find_copyright_by_name!(copyright_name)
          return if copyright_name.blank?

          copyrighttypes = { 'あり' => true, 'なし' => false }
          copyright_flag = copyrighttypes[copyright_name]
          if copyright_flag.nil?
            raise Shinonome::ExecCommand::FormatError,
                  I18n.t('errors.exec_command.copyrighttype_invalid', copyrighttypes: %("#{copyrighttypes.keys.join('"か"')}"))
          end

          copyright_flag
        end

        def find_work_status_by_name!(work_status_name)
          work_statuses = WorkStatus.order(:id).pluck(:name)
          work_status = WorkStatus.where(id: work_status_name).first || WorkStatus.where(name: work_status_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_status_invalid', work_statuses: %("#{work_statuses.join('"か"')}")) unless work_status

          work_status
        end

        def find_workfile!(workfile_id)
          Workfile.find(workfile_id)
        rescue ActiveRecord::RecordNotFound
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.workfile_not_found')
        end
      end
    end
  end
end
