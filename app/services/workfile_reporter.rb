# frozen_string_literal: true

# 転送用に直近1週間ほどの更新ファイルを抽出し出力する
class WorkfileReporter
  attr_reader :past_days, :future_days, :output_file, :include_details, :workfiles, :check_file_exists

  def initialize(past_days: 7, future_days: 0, output_file: nil, include_details: false, check_file_exists: false, days: nil)
    # Backward compatibility support
    if days
      @past_days = days
      @future_days = 0
    else
      @past_days = past_days
      @future_days = future_days
    end

    @output_file = output_file || default_output_file
    @include_details = include_details
    @check_file_exists = check_file_exists
    @workfiles = nil
  end

  def generate_report
    @workfiles = fetch_recent_workfiles

    report_data = if include_details
                    generate_detailed_report_data(@workfiles)
                  else
                    generate_simple_report_data(@workfiles)
                  end

    {
      data: report_data,
      count: @workfiles.count,
      period: { start: start_date, end: end_date },
      generated_at: Time.current
    }
  end

  private

  def default_output_file
    Rails.root.join('tmp/recent_workfiles_list.txt')
  end

  def start_date
    @start_date ||= past_days.days.ago.to_date
  end

  def end_date
    @end_date ||= future_days.days.from_now.to_date
  end

  def fetch_recent_workfiles
    Workfile
      .joins(:work)
      .where(registered_on: start_date..end_date)
      .includes(work: { work_people: :person })
      .order('workfiles.registered_on DESC, works.id ASC')
  end

  def generate_simple_report_data(workfiles)
    if check_file_exists
      workfiles.filter_map do |workfile|
        if workfile.file_exists?
          # rsync用の相対パスを生成（data/ディレクトリからの相対パス）
          relative_path = workfile.filesystem.path.to_s.sub(%r{^.*/data/}, '')
          {
            path: relative_path,
            workfile_id: workfile.id
          }
        end
      end
    else
      workfiles.map do |workfile|
        # rsync用の相対パスを生成（data/ディレクトリからの相対パス）
        relative_path = workfile.filesystem.path.to_s.sub(%r{^.*/data/}, '')
        {
          path: relative_path,
          workfile_id: workfile.id
        }
      end
    end
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

  def generate_detailed_report_data(workfiles)
    {
      title: 'Recently Published Workfiles Report',
      generated: Time.current,
      period: "#{start_date} to #{end_date} (past: #{past_days} days, future: #{future_days} days)",
      total_files: workfiles.count,
      workfiles: workfiles.map { |workfile| generate_workfile_data(workfile) }
    }
  end

  def write_detailed_report(file, workfiles)
    file.puts 'Recently Published Workfiles Report'
    file.puts '==================================='
    file.puts "Generated: #{Time.current}"
    file.puts "Period: #{start_date} to #{end_date} (past: #{past_days} days, future: #{future_days} days)"
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

  def generate_workfile_data(workfile)
    authors = workfile.work.work_people
                      .joins(:person)
                      .where(role_id: 1)
                      .pluck('people.last_name', 'people.first_name')
                      .map { |last, first| "#{last} #{first}".strip }
                      .join(', ')

    {
      registered_on: workfile.registered_on,
      work_id: workfile.work_id,
      title: workfile.work.title,
      subtitle: workfile.work.subtitle,
      authors: authors,
      workfile_id: workfile.id,
      filename: workfile.filename,
      url: workfile.url,
      download_url: workfile.download_url,
      filetype: workfile.filetype&.name,
      filesize: workfile.filesize,
      charset: workfile.charset&.name,
      compression: workfile.compresstype&.name
    }
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
