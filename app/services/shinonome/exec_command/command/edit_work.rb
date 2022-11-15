# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品更新
      class EditWork < Base
        COLUMN_NAMES = %i[title title_kana subtitle subtitle_kana collection collection_kana original_title first_appearance description note orig_text started_on sortkey].freeze
        OPTS_KEYS = COLUMN_NAMES + %i[work_id kana_type_name work_status_name copyright_name user_id]
        ARGS_NAMES = %i[work_id
                        title
                        title_kana
                        subtitle
                        subtitle_kana
                        collection
                        collection_kana
                        original_title
                        kana_type_name
                        first_appearance
                        description
                        note
                        orig_text
                        work_status_name
                        started_on
                        copyright_name
                        sortkey
                        user_id].freeze

        def execute(command)
          opts = ARGS_NAMES.zip(command.body).to_h
          update_values = {}

          work = find_work!(opts[:work_id])

          copyright_flag = find_copyright_by_name!(opts[:copyright_name]) if opts[:copyright_name].present?
          kana_type = find_kana_type_by_name!(opts[:kana_type_name]) if opts[:kana_type_name].present?
          work_status = find_work_status_by_name!(opts[:work_status_name]) if opts[:work_status_name].present?

          # sortkeyは自動生成しない
          COLUMN_NAMES.each do |column_name|
            next if opts[column_name].blank?

            update_values[column_name] = if opts[column_name] == 'null'
                                           nil
                                         else
                                           opts[column_name]
                                         end
          end

          update_values[:copyright_flag] = copyright_flag if copyright_flag
          update_values[:kana_type_id] = kana_type.id if kana_type
          update_values[:work_status_id] = work_status.id if work_status
          update_values[:user_id] = opts[:user_id]

          work.update!(update_values)

          Result.new(executed: true, command_result: work)
        end
      end
    end
  end
end
