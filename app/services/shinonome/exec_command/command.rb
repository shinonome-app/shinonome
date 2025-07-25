# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class Command # rubocop:disable Style/Documentation
      COMMAND_NAMES = {
        '作品新規' => AddWork,
        '底本追加' => AddOriginalBook,
        '分類追加' => AddBibclass,
        '人物追加' => AddPerson,
        '耕作員追加' => AddWorker,
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
        'book_worker' => GetWorkWorker,
        'source' => GetOriginalBook,
        'class' => GetBibclass,
        'person' => GetPerson,
        'worker' => GetWorker,
        'site' => GetSite,
        '耕作員削除' => DeleteWorker
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
          @is_comment = false
          @prev_command = prev_command
        else
          # normal line
          @name = row[0]
          @body = row[1..]
          @is_comment = false
          @prev_command = prev_command
          @pass_work_id = @name == '作品新規' || %w[bookselect book person worker site book_site person_site book_person book_worker source class].include?(@name)

          # Skip work_id validation for 作品新規
          if @pass_work_id
            @work_id = nil
          else
            # Validate work_id is numeric before converting
            raise FormatError, I18n.t('errors.exec_command.book_id_numeric') if @body[0].present? && @body[0].is_a?(String) && !@body[0].match?(/\A-?\d+\z/)

            @work_id = @body[0].to_i
            raise FormatError, I18n.t('errors.command_parser.invalid_work_id', work_id: @work_id) if @work_id < 0
          end
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

      def execute(output_dir:)
        instance = command_class.new
        if instance.method(:execute).parameters.any? { |_type, name| name == :output_dir }
          instance.execute(self, output_dir:)
        else
          instance.execute(self)
        end
      end

      private

      def valid_command_name?(name)
        COMMAND_NAMES.keys.include?(name)
      end
    end
  end
end
