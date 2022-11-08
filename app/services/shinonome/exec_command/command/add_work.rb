# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command
      # 作品追加
      class AddWork < Base
        # rubocop:disable Metrics/ParameterLists
        def execute(
          title:,
          title_kana:,
          subtitle:,
          subtitle_kana:,
          collection:,
          collection_kana:,
          original_title:,
          kana_type_name:,
          first_appearance:,
          description:,
          note:,
          orig_text:,
          work_status_name:,
          started_on:,
          copyright_name:,
          sortkey:,
          user_id:
        )
          # rubocop:enable Metrics/ParameterLists

          copyrighttypes = { 'あり' => true, 'なし' => false }
          copyright_flag = copyrighttypes[copyright_name]
          if copyright_flag.nil?
            raise Shinonome::ExecCommand::FormatError,
                  I18n.t('errors.exec_command.copyrighttype_invalid', copyrighttypes: %("#{copyrighttypes.keys.join('"か"')}"))
          end

          kana_types = KanaType.order(:id).pluck(:name)
          kana_type  = KanaType.where(name: kana_type_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.kana_type_invalid', kana_types: %("#{kana_types.join('"か"')}")) unless kana_type

          work_statuses = WorkStatus.order(:id).pluck(:name)
          work_status = WorkStatus.where(id: work_status_name).first || WorkStatus.where(name: work_status_name).first
          raise Shinonome::ExecCommand::FormatError, I18n.t('errors.exec_command.work_status_invalid', work_statuses: %("#{work_statuses.join('"か"')}")) unless work_status

          sortkey = Kana.convert_sortkey(title_kana) if sortkey.blank?

          book = Work.create!(
            title: title,
            title_kana: title_kana,
            subtitle: subtitle,
            subtitle_kana: subtitle_kana,
            collection: collection,
            collection_kana: collection_kana,
            original_title: original_title,
            kana_type_id: kana_type.id,
            first_appearance: first_appearance,
            description: description,
            note: note,
            orig_text: orig_text,
            work_status_id: work_status.id,
            started_on: started_on,
            copyright_flag: copyright_flag,
            sortkey: sortkey,
            user_id: user_id
          )

          Result.new(executed: true, command_result: book)
        end
      end
    end
  end
end
