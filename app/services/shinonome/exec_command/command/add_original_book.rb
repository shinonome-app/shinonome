# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本追加
      class AddOriginalBook < Base
        def execute(command)
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.invalid_argument_number') if command.body.size > 8

          work_id, title, publisher, first_pubdate, input_edition, proof_edition, booktype_name, note = command.body

          work = find_work!(work_id)
          booktype = find_booktype_by_name!(booktype_name)

          original_book = OriginalBook.create!(work_id: work.id,
                                               first_pubdate: first_pubdate,
                                               input_edition: input_edition,
                                               proof_edition: proof_edition,
                                               publisher: publisher,
                                               title: title,
                                               booktype_id: booktype.id,
                                               original_book_secret_attributes: { memo: note }
                                              )

          Result.new(executed: true, command_result: original_book)
        end
      end
    end
  end
end
