# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本追加
      class AddOriginalBook < Base
        def execute(*args)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.invalid_argument_number') if args.size != 8

          work_id, title, publisher, first_pubdate, input_edition, proof_edition, worktype_name, note = args

          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.book_id_numeric') unless work_id.to_s.match?(/\A[1-9]\d*\z/)

          worktypes = Worktype.order(:id).pluck(:name)
          worktype = Worktype.where(name: worktype_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.worktype_not_found', %("#{worktypes.join('"か"')}")) unless worktype

          begin
            _work = Work.find(work_id)
          rescue ActiveRecord::RecordNotFound
            raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_not_found')
          end

          original_book = OriginalBook.create!(work_id: work_id,
                                               first_pubdate: first_pubdate,
                                               input_edition: input_edition,
                                               note: note,
                                               proof_edition: proof_edition,
                                               publisher: publisher,
                                               title: title,
                                               worktype_id: worktype.id)

          Result.new(executed: true, command_result: original_book)
        end
      end
    end
  end
end
