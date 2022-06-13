# frozen_string_literal: true

module Shinonome
  class ExecCommand
    class CommandParser # rubocop:disable Style/Documentation
      class FormatError < StandardError
      end

      FORMATS = %i[tsv csv].freeze

      def parse(command_text, format: :tsv)
        parse_text(command_text, format: format)
      end

      def parse_text(command_text, format:)
        case format
        when :tsv
          buf = []
          errors = []
          line_num = 0
          command_text.each_line do |line|
            line_num += 1
            row = parse_tsv_line(line)
            begin
              command = Command.new(row)
              next if command.comment?
            rescue ForamtError => e
              errors << "line #{line_num}: #{e.message}"
            end
            buf << command if command
          end

          if errors.empty?
            buf
          else
            e = FormatError.new(erros.join("\n"))
            raise e
          end

        when :csv
          buf = []

          line_num = 0
          CSV.parse(commands) do |row|
            line_num += 1
            command = Command.new(row)
            buf << command if command
          end

          buf
        else
          raise FormatError, I18n.t('errors.command_parser.invalid_format')
        end
      end

      private

      def parse_tsv_line(line)
        line.split("\t")
      end
    end
  end
end
