# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品追加
      class AddWork < Base
        def execute(command)
          title,
          title_kana,
          subtitle,
          subtitle_kana,
          collection,
          collection_kana,
          original_title,
          kana_type_name,
          first_appearance,
          description,
          note,
          orig_text,
          work_status_name,
          started_on,
          copyright_name,
          sortkey,
          user_id = command.body

          copyright_flag = find_copyright_by_name!(copyright_name.presence || 'あり')
          kana_type = find_kana_type_by_name!(kana_type_name)
          work_status = find_work_status_by_name!(work_status_name)

          sortkey = Kana.convert_sortkey(title_kana) if sortkey.blank?

          work = Work.create!(
            title:,
            title_kana:,
            subtitle:,
            subtitle_kana:,
            collection:,
            collection_kana:,
            original_title:,
            kana_type_id: kana_type.id,
            first_appearance:,
            description:,
            note:,
            work_status_id: work_status.id,
            started_on:,
            copyright_flag:,
            sortkey:,
            user_id:,
            work_secret_attributes: { orig_text: }
          )

          Result.new(executed: true, command_result: work)
        end
      end
    end
  end
end
