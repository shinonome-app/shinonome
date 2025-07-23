# frozen_string_literal: true

# 作品ファイルを転送する
class WorkfileTransferer
  attr_reader :past_days, :future_days, :rsync_keyfile, :server_path

  def initialize(past_days: 3, future_days: 0)
    @past_days = past_days
    @future_days = future_days
    @rsync_keyfile = Rails.root.join('tmp/rsync.key')
    @server_path = ENV.fetch('RSYNC_SERVER_PATH', nil)

    write_rsync_keyfile
  end

  def transfer_files
    workfiles = recent_published_works.flat_map { |work| work.workfiles }

    workfiles.each do |workfile|
      src_path = workfile.filesystem.path
      next unless src_path

      remote_path = "#{server_path}/#{src_path.to_s.sub(%r{^.*/data/workfiles/}, '')}"

      cmd = "rsync -avhz -e \"ssh -o StrictHostKeyChecking=no -i #{rsync_keyfile}\" #{src_path} #{remote_path}"
      Rails.logger.info(cmd)

      system(cmd)
    end
  end

  def output_paths(output_file = Rails.root.join('data/rsync_paths.txt'))
    workfiles = recent_published_works.flat_map { |work| work.workfiles }

    File.open(output_file, 'w') do |file|
      workfiles.each do |workfile|
        src_path = workfile.filesystem.path
        next unless src_path

        remote_path = "#{server_path}/#{src_path.to_s.sub(%r{^.*/data/workfiles/}, '')}"
        file.puts "#{src_path};#{remote_path}"
      end
    end

    output_file
  end

  private

  def write_rsync_keyfile
    File.write(rsync_keyfile, ENV.fetch('RSYNC_PASS_FILE', '').gsub('@NL@', "\n"))
    FileUtils.chmod(0o600, rsync_keyfile)
  end

  def start_date
    @start_date ||= past_days.days.ago.to_date
  end

  def end_date
    @end_date ||= future_days.days.from_now.to_date
  end

  def recent_published_works
    Work.published.includes(:workfiles)
        .where(started_on: start_date..end_date)
        .order('started_on ASC, id ASC')
  end
end
