# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command # rubocop:disable Style/Documentation
      COMMAND_NAMES = {
        add_work: '作品新規',
        add_original_book: '底本追加',
        add_bibclass: '分類追加',
        add_person: '人物追加',
        add_worker: '工作員追加',
        add_site: 'サイト追加',
        add_file: 'ファイル追加',
        edit_work: '作品更新',
        edit_original_book: '底本更新',
        edit_bibclass: '分類更新',
        edit_file: 'ファイル更新',
        delete_file: 'ファイル削除',
        delete_original_book: '底本削除',
        delete_bibclass: '分類削除',
        delete_site: 'サイト削除',
        command_sql: 'SQL',
        get_file: 'ファイル取得',
        get_work_select: 'bookselect',
        get_work: 'book',
        get_work_site: 'book_site',
        get_person_site: 'person_site',
        get_work_person: 'book_person',
        get_work_walker: 'book_worker',
        get_original_book: 'source',
        get_bibclass: 'class',
        get_person: 'person',
        get_worker: 'worker',
        get_site: 'site',
        delete_worker: '工作員削除'
      }.freeze

      COMMAND_NAMES_INVERTED = COMMAND_NAMES.invert.freeze

      attr_reader :name, :work_id, :body

      def initialize(row)
        @name = row[0]
        @work_id = row[1].to_i
        @body = row[2..]
        @is_comment = false

        if @name.start_with('#')
          @is_comment = true
          return
        elsif @name.blank?
          @name = row[1]
          if @name.start_with('#')
            @is_comment = true
            return
          end

          @work_id = nil
        elsif @work_id <= 0
          raise FormatError, I18n.t('errors.command_parser.invalid_work_id', work_id: @work_id)
        end

        raise FormatError, I18n.t('errors.command_parser.invalid_command', name: @name) unless valid_command_name?(@name)
      end

      def comment?
        @is_comment
      end

      def command_class
        @name
      end

      private

      def valid_command_name?(name)
        COMMAND_NAMES_INVERTED.values.include?(name)
      end
    end
  end
end
