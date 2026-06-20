# frozen_string_literal: true

namespace :workfiles do
  desc 'Restore missing workfiles from old flat directory'
  task :restore_missing, [:source_dir] => :environment do |_task, args|
    source_dir = args[:source_dir]

    if source_dir.blank?
      puts 'Usage: bin/rails workfiles:restore_missing[/path/to/old/files]'
      exit 1
    end

    unless Dir.exist?(source_dir)
      puts "Error: Source directory not found: #{source_dir}"
      exit 1
    end

    puts "Source directory: #{source_dir}"
    puts 'Scanning for missing files...'

    restored = 0
    not_found = 0
    errors = 0
    skipped = 0

    Workfile.includes(:work).find_each do |workfile|
      # URLがある場合はスキップ（外部リンク）
      next if workfile.url.present?

      # 既に存在する場合はスキップ
      if workfile.file_exists?
        skipped += 1
        next
      end

      filename = workfile.filename.presence || workfile.generate_filename
      next if filename.blank?

      source_path = File.join(source_dir, filename)

      unless File.exist?(source_path)
        not_found += 1
        puts "  Not found: #{filename} (workfile_id: #{workfile.id}, work_id: #{workfile.work_id})"
        next
      end

      begin
        workfile.filesystem.copy_from(source_path)
        restored += 1
        puts "  Restored: #{filename}"
      rescue StandardError => e
        errors += 1
        puts "  Error: #{filename} - #{e.message}"
      end
    end

    puts
    puts '=== Summary ==='
    puts "Skipped (already exists): #{skipped}"
    puts "Restored: #{restored}"
    puts "Not found in source: #{not_found}"
    puts "Errors: #{errors}"
  end

  desc 'Check missing workfiles (dry run)'
  task :check_missing, [:source_dir] => :environment do |_task, args|
    source_dir = args[:source_dir]

    puts 'Checking missing workfiles...'
    puts "Source directory: #{source_dir || '(not specified)'}"
    puts

    missing_count = 0
    found_in_source = 0
    not_in_source = 0

    Workfile.includes(:work).find_each do |workfile|
      next if workfile.url.present?
      next if workfile.file_exists?

      missing_count += 1
      filename = workfile.filename.presence || workfile.generate_filename
      next if filename.blank?

      if source_dir.present? && File.exist?(File.join(source_dir, filename))
        found_in_source += 1
      else
        not_in_source += 1
        puts "  Missing: #{filename} (workfile_id: #{workfile.id}, work_id: #{workfile.work_id}, status: #{workfile.work.work_status_id})"
      end
    end

    puts
    puts '=== Summary ==='
    puts "Total missing: #{missing_count}"
    if source_dir.present?
      puts "Found in source: #{found_in_source}"
      puts "Not in source: #{not_in_source}"
    end
  end
end
