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

  desc 'Restore legacy (blank-filename) workfiles from a flat source, filling filename ONLY when the file actually exists. APPLY=1 to write.'
  task :restore_legacy, [:source_dir] => :environment do |_task, args|
    source_dir = args[:source_dir]
    if source_dir.blank? || !Dir.exist?(source_dir)
      puts "Usage: bin/rails 'workfiles:restore_legacy[/path/to/flat_source]'  (APPLY=1 to write)"
      puts "Error: source dir not found: #{source_dir}" if source_dir.present?
      exit 1
    end

    apply = ENV['APPLY'] == '1'
    restored = 0
    not_found = 0
    errors = 0

    # 旧 www(bookcard.php) の「ファイル名空」時の命名規則を再現し、その名前のファイルが
    # source に実在するときだけ filename を埋めてファイルを復元する（機械的な fill はしない）。
    #   rtxt  : 圧縮なし → <work_id>_ruby.txt   / 圧縮あり → <work_id>_ruby.<arc>
    #   それ以外: 圧縮なし → <work_id>.<ext>      / 圧縮あり → <work_id>_<ext>.<arc>
    # （work_id は旧 bookid。公開URL <bookid>.<ext> を維持。実体が無いものは触らない）
    Workfile.includes(:work, :filetype, :compresstype).find_each do |wf|
      next if wf.url.present?
      next if wf.filename.present? # 既に名前があるものは既存 restore_missing の対象

      ft = wf.filetype
      ct = wf.compresstype
      next if ft.nil? || ct.nil?

      arc = ct.extension # 'none' / 'zip' など
      ext = ft.extension # 'ebk' / 'html' など
      name =
        if ft.rtxt?
          arc == 'none' ? "#{wf.work_id}_ruby.txt" : "#{wf.work_id}_ruby.#{arc}"
        elsif arc == 'none'
          "#{wf.work_id}.#{ext}"
        else
          "#{wf.work_id}_#{ext}.#{arc}"
        end

      source_path = File.join(source_dir, name)
      unless File.exist?(source_path)
        not_found += 1
        next
      end

      begin
        if apply
          # path 導出は filename を見るので、コピー前に filename を確定させる
          wf.update_columns(filename: name) # rubocop:disable Rails/SkipsModelValidations
          wf.filesystem.copy_from(source_path)
        end
        restored += 1
        puts "  Restored: #{name} (workfile_id: #{wf.id}, work_id: #{wf.work_id}, #{ft.name})"
      rescue StandardError => e
        errors += 1
        puts "  Error: #{name} (workfile_id: #{wf.id}) - #{e.message}"
      end
    end

    puts
    puts "=== Summary (#{apply ? 'APPLIED' : 'DRY RUN'}) ==="
    puts "Restored (file exists -> filled + copied): #{restored}"
    puts "Skipped (no file in source): #{not_found}"
    puts "Errors: #{errors}"
    puts '(書き込むには APPLY=1 を付けて再実行)' unless apply
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
