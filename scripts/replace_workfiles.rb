#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'

dir = ENV.fetch('WORKFILES_DIR', '/var/tmp/workfiles')
dry_run = ENV['DRY_RUN'] == '1'
verbose = ENV['VERBOSE'] == '1'

errors = []
reasons = Hash.new(0)
processed = 0
total = 0

unless Dir.exist?(dir)
  warn "ERROR: directory not found: #{dir}"
  exit 1
end

Dir.glob(File.join(dir, '*')).each do |path|
  next unless File.file?(path)

  total += 1
  base = File.basename(path)
  match = base.match(/\A(?<work_id>\d+)(?:_(?<exttag>[^_]+))?_(?<workfile_id>\d+)\.(?<ext>[^.]+)\z/)
  unless match
    errors << "name mismatch: #{base}"
    reasons[:name_mismatch] += 1
    next
  end

  workfile = Workfile.find_by(id: match[:workfile_id], work_id: match[:work_id])
  if workfile.nil?
    errors << "not found: #{base} (work_id=#{match[:work_id]}, workfile_id=#{match[:workfile_id]})"
    reasons[:not_found] += 1
    next
  end

  if workfile.url.present?
    errors << "skip url workfile: #{base}"
    reasons[:url_present] += 1
    next
  end

  if workfile.filename.blank?
    errors << "db filename blank: #{base}"
    reasons[:db_filename_blank] += 1
    next
  end

  if workfile.filename != base
    errors << "db filename mismatch: #{base} db=#{workfile.filename}"
    reasons[:db_filename_mismatch] += 1
    next
  end

  expected = workfile.generate_filename
  if expected != base
    errors << "filename mismatch: #{base} expected=#{expected}"
    reasons[:filename_mismatch] += 1
    next
  end

  if File.size(path).zero?
    errors << "zero size: #{base}"
    reasons[:zero_size] += 1
    next
  end

  dest = workfile.filesystem.path
  if dry_run
    puts "[DRY RUN] replace #{base} -> #{dest}" if verbose
    processed += 1
    next
  end

  FileUtils.mkdir_p(File.dirname(dest))
  FileUtils.cp(path, dest)

  workfile.update!(
    filesize: File.size(dest),
    revision_count: (workfile.revision_count || 0) + 1,
    updated_at: Time.zone.now
  )

  processed += 1
end

puts "total: #{total}"
puts "processed: #{processed}"
puts "dry_run: #{dry_run}"
puts "skipped: #{reasons.values.sum}"
reasons.sort_by { |key, _| key.to_s }.each do |key, count|
  puts "skipped_#{key}: #{count}"
end
puts errors.join("\n")
