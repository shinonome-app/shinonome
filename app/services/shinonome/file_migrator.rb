# frozen_string_literal: true

module Shinonome
  # migrate files from old system
  class FileMigrator
    include DiskFolder

    def migrate_files(dir:)
      Workfile.find_each do |workfile|
        filename = workfile.filename
        next if filename.blank?

        path = File.join(dir, filename)
        content_type = content_type_for(filename)
        if File.exist?(path)
          workfile.workdata.attach(
            io: File.open(path),
            filename:,
            content_type:
          )
        else
          Rails.logger.info("file not found: '#{path}' (workfile #{workfile.id}).")
        end
      end
    end

    private

    def content_type_for(filename)
      case filename
      when /\.zip$/
        'application/zip'
      when /\.html$/
        'text/html'
      else
        'application/octet-stream'
      end
    end
  end
end
