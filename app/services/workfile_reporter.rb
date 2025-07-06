# frozen_string_literal: true

# 転送用に直近1週間ほどの更新ファイルを抽出し出力する
class WorkfileReporter
  attr_reader :days, :output_file, :include_details

  def initialize(days: 7, output_file: nil, include_details: false)
    @days = days
    @output_file = output_file || default_output_file
    @include_details = include_details
  end

  def generate_report
    workfiles = fetch_recent_workfiles

    File.open(output_file, 'w') do |file|
      if include_details
        write_detailed_report(file, workfiles)
      else
        write_simple_report(file, workfiles)
      end
    end

    {
      output_file: output_file,
      count: workfiles.count,
      period: { start: start_date, end: end_date }
    }
  end

  private

  def default_output_file
    Rails.root.join('tmp/recent_workfiles_list.txt')
  end

  def start_date
    @start_date ||= days.days.ago.to_date
  end

  def end_date
    @end_date ||= Date.current
  end

  def fetch_recent_workfiles
    Workfile
      .joins(:work)
      .where(registered_on: start_date..end_date)
      .includes(work: { work_people: :person })
      .order('workfiles.registered_on DESC, works.id ASC')
  end

  def write_simple_report(file, workfiles)
    workfiles.find_each do |workfile|
      if workfile.file_exists?
        # rsync用の相対パスを生成（data/ディレクトリからの相対パス）
        relative_path = workfile.filesystem.path.to_s.sub(%r{^.*/data/}, '')
        file.puts relative_path
      end
    end
  end

  def write_detailed_report(file, workfiles)
    file.puts 'Recently Published Workfiles Report'
    file.puts '==================================='
    file.puts "Generated: #{Time.current}"
    file.puts "Period: #{start_date} to #{end_date} (#{days} days)"
    file.puts "Total files found: #{workfiles.count}"
    file.puts
    file.puts 'Details:'
    file.puts '-' * 80

    if workfiles.any?
      workfiles.find_each do |workfile|
        write_workfile_details(file, workfile)
      end
    else
      file.puts 'No workfiles found for the specified period.'
    end
  end

  def write_workfile_details(file, workfile)
    authors = workfile.work.work_people
                      .joins(:person)
                      .where(role_id: 1)
                      .pluck('people.last_name', 'people.first_name')
                      .map { |last, first| "#{last} #{first}".strip }
                      .join(', ')

    file.puts
    file.puts "Registered: #{workfile.registered_on}"
    file.puts "Work ID: #{workfile.work_id}"
    file.puts "Title: #{workfile.work.title}"
    file.puts "Subtitle: #{workfile.work.subtitle}" if workfile.work.subtitle.present?
    file.puts "Author(s): #{authors}"
    file.puts "Workfile ID: #{workfile.id}"
    file.puts "Filename: #{workfile.filename || 'N/A'}"
    file.puts "URL: #{workfile.url}" if workfile.url.present?
    file.puts "Download URL: #{workfile.download_url}"
    file.puts "Filetype: #{workfile.filetype.name}" if workfile.filetype
    file.puts "Filesize: #{workfile.filesize}" if workfile.filesize
    file.puts "Charset: #{workfile.charset.name}" if workfile.charset
    file.puts "Compression: #{workfile.compresstype.name}" if workfile.compresstype
    file.puts '-' * 80
  end
end
