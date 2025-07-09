# frozen_string_literal: true

# 作品ファイルを転送する
class WorkfileTransferer
  attr_reader :days, :rsync_keyfile, :server_path

  def initialize(days: 3)
    @days = days
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

  private

  def write_rsync_keyfile
    File.write(rsync_keyfile, ENV.fetch('RSYNC_PASS_FILE', ''))
  end

  def start_date
    @start_date ||= days.days.ago.to_date
  end

  def end_date
    @end_date ||= Date.current
  end

  def recent_published_works
    Work.published.includes(:workfiles)
        .where(started_on: start_date..end_date)
        .order('started_on ASC, id ASC')
  end
end
