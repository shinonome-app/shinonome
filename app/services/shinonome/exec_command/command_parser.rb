# frozen_string_literal: true

require 'csv'

module Shinonome
  class ExecCommand
    class CommandParser # rubocop:disable Style/Documentation
      FORMATS = %i[tsv csv].freeze

      def parse(command_text, format: :tsv)
        case format
        when :tsv
          parse_tsv(command_text)
        when :csv
          parse_csv(command_text)
        else
          raise FormatError, I18n.t('errors.command_parser.invalid_format')
        end
      end

      def parse_tsv(command_text)
        parsed_commands = []
        errors = []
        line_num = 0
        prev_command = nil

        command_text.each_line do |line|
          row = parse_tsv_line(line.chomp)
          line_num += 1

          next if row.empty?

          begin
            command = Command.new(row, prev_command:)
          rescue FormatError => e
            errors << "#{line_num}行目: Syntax Error: #{e.message}"
            next
          end

          next if command.blank? || command.comment?

          parsed_commands << command if command
          prev_command = command
        end

        unless errors.empty?
          e = FormatError.new(errors.join("\n"))
          raise e
        end

        parsed_commands
      end

      def parse_csv(command_text)
        parsed_commands = []
        errors = []
        line_num = 0
        prev_command = nil

        CSV.parse(command_text) do |row|
          line_num += 1

          next if row.empty?

          begin
            command = Command.new(row, prev_command:)
          rescue FormatError => e
            errors << "line #{line_num}: #{e.message}"
            next
          end

          next if command.blank? || command.comment?

          parsed_commands << command
          prev_command = command
        end

        unless errors.empty?
          e = FormatError.new(errors.join("\n"))
          raise e
        end

        parsed_commands
      end

      private

      def parse_tsv_line(line)
        line.split("\t")
      end
    end
  end
end
