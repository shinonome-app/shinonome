# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 底本更新
      class EditOriginalBook < Base
        def execute(command)
          raise ArgumentError, I18n.t('errors.exec_command.invalid_argument_number') if command.body.size > 8

          work_id, title, publisher, first_pubdate, input_edition, proof_edition, booktype_name, note = command.body

          work = find_work!(work_id)
          booktype = find_booktype_by_name!(booktype_name)

          update_values = {
            first_pubdate: first_pubdate,
            input_edition: input_edition,
            proof_edition: proof_edition,
            booktype_id: booktype.id,
            original_book_secret_attributes: { memo: note },
          }

          update_values.reject! { |_, val| val == '' }
          update_values.each do |key, val|
            update_values[key] = '' if val == 'null'
          end

          OriginalBook.where(
            work_id: work.id,
            publisher: publisher,
            title: title
          ).find_each { |original_book| original_book.update!(update_values) }

          original_books = OriginalBook.where(
            work_id: work.id,
            publisher: publisher,
            title: title
          )

          Result.new(executed: true, command_result: original_books)
        end
      end
    end
  end
end
