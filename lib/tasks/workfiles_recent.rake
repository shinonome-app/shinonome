# frozen_string_literal: true

# Rake task to find recently published workfiles
#
# Usage:
#   bundle exec rake workfiles:recent
#   bundle exec rake workfiles:recent DAYS=30
#   bundle exec rake workfiles:recent DAYS=14 OUTPUT_FILE=/tmp/recent_files.txt
#   bundle exec rake workfiles:recent DETAILS=true  # for detailed output
#
# Parameters:
#   DAYS - Number of days to look back (default: 7)
#   OUTPUT_FILE - Path to output file (default: tmp/recent_workfiles_TIMESTAMP.txt)
#   DETAILS - Include detailed information (default: false, only filenames)
#

namespace :workfiles do
  desc 'Find workfiles published in the last N days and output to a file'
  task recent: :environment do
    # Get parameters with defaults
    days = ENV.fetch('DAYS', '7').to_i
    output_file = ENV.fetch('OUTPUT_FILE', nil)
    include_details = ENV.fetch('DETAILS', 'false').downcase == 'true'

    puts "Finding workfiles published in the last #{days} days..."

    # Use the service class to generate the report
    reporter = WorkfileReporter.new(
      days: days,
      output_file: output_file,
      include_details: include_details
    )

    result = reporter.generate_report

    puts "Report generated: #{result[:output_file]}"
    puts "Found #{result[:count]} workfile(s)"
    puts "Period: #{result[:period][:start]} to #{result[:period][:end]}"
  end
end
