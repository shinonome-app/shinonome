# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本更新
      class EditOriginalBook < Base
        def execute(*args)
          raise ArgumentError, I18n.t('errors.exec_command.invalid_argument_number') if args.size != 8

          work_id, title, publisher, first_pubdate, input_edition, proof_edition, worktype_name, note = args

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          worktypes = Worktype.order(:id).pluck(:name)
          worktype = Worktype.where(name: worktype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.worktype_invalid', worktypes: %("#{worktypes.join('"か"')}")) unless worktype

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found', work_id: work_id)
          end

          update_values = {
            first_pubdate: first_pubdate,
            input_edition: input_edition,
            note: note,
            proof_edition: proof_edition,
            worktype_id: worktype.id
          }

          update_values.reject! { |_, val| val == '' }
          update_values.each do |key, val|
            update_values[key] = '' if val == 'null'
          end

          OriginalBook.where(
            work_id: work_id,
            publisher: publisher,
            title: title
          ).each { |original_book| original_book.update!(update_values) }

          original_books = OriginalBook.where(
            work_id: work_id,
            publisher: publisher,
            title: title
          )

          Result.new(executed: true, command_result: original_books)
        end
      end
    end
  end
end
