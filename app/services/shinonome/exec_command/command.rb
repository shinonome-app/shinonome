# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command # rubocop:disable Style/Documentation
      COMMAND_NAMES = {
        '作品新規' => AddWork,
        '底本追加' => AddOriginalBook,
        '分類追加' => AddBibclass,
        '人物追加' => AddPerson,
        '工作員追加' => AddWorker,
        'サイト追加' => AddSite,
        'ファイル追加' => AddFile,
        '作品更新' => EditWork,
        '底本更新' => EditOriginalBook,
        '分類更新' => EditBibclass,
        'ファイル更新' => EditFile,
        'ファイル削除' => DeleteFile,
        '底本削除' => DeleteOriginalBook,
        '分類削除' => DeleteBibclass,
        'サイト削除' => DeleteSite,
        'SQL' => CommandSql,
        'ファイル取得' => GetFile,
        'bookselect' => GetWorkSelect,
        'book' => GetWork,
        'book_site' => GetWorkSite,
        'person_site' => GetPersonSite,
        'book_person' => GetWorkPerson,
        'book_worker' => GetWorkWalker,
        'source' => GetOriginalBook,
        'class' => GetBibclass,
        'person' => GetPerson,
        'worker' => GetWorker,
        'site' => GetSite,
        '工作員削除' => DeleteWorker
      }.freeze

      attr_reader :name, :body, :row

      def initialize(row, prev_command: nil)
        @row = row

        if row[0].start_with?('#')
          # comment line
          @name = nil
          @body = []
          @work_id = nil
          @is_comment = true
          return
        end

        if row[0].blank?
          # continuation line
          @name = row[1]

          if @name.start_with?('#')
            @name = nil
            @body = []
            @work_id = nil
            @is_comment = true
            return
          end

          @body = row[2..]
          @work_id = nil
          @pass_work_id = true
        else
          # normal line
          @name = row[0]
          @body = row[1..]
          @work_id = row[1].to_i
          @is_comment = false
          @prev_command = prev_command

          raise FormatError, I18n.t('errors.command_parser.invalid_work_id', work_id: @work_id) if @work_id < 0

          @pass_work_id = @name == '作品新規'
        end

        raise FormatError, I18n.t('errors.command_parser.invalid_command', name: @name) unless valid_command_name?(@name)
      end

      def work_id
        if @work_id
          @work_id
        elsif @prev_command&.pass_work_id?
          @prev_command.work_id
        end
      end

      def comment?
        @is_comment
      end

      def pass_work_id?
        @pass_work_id
      end

      def command_class
        COMMAND_NAMES[@name]
      end

      def execute
        command_class.new(self).execute
      end

      private

      def valid_command_name?(name)
        COMMAND_NAMES.keys.include?(name)
      end
    end
  end
end
