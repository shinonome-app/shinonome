# frozen_string_literal: true

namespace :storage do # rubocop:disable Metrics/BlockLength
  desc 'Migrate files from ActiveStorage to filesystem'
  task migrate_to_filesystem: :environment do
    # Limit for testing (can be overridden with LIMIT env var)
    limit = ENV['LIMIT']&.to_i || 10
    puts '開始: ActiveStorageからファイルシステムへの移行'
    puts "時刻: #{Time.current}"
    puts

    migrated_count = 0
    error_count = 0
    skipped_count = 0
    total_count = 0

    # Progress tracking
    query = Workfile.joins(:workdata_attachment).distinct

    # Allow targeting specific IDs for testing
    if ENV['IDS']
      ids = ENV['IDS'].split(',').map(&:to_i)
      query = query.where(id: ids)
    else
      query = query.limit(limit)
    end

    workfiles_with_activestorage = query
    total_files = workfiles_with_activestorage.count

    puts "移行制限: #{limit}件"
    puts "移行対象ファイル数: #{total_files}"
    puts

    workfiles_with_activestorage.includes(:work).find_each.with_index do |workfile, index|
      total_count += 1

      # Progress indicator
      puts "進捗: #{index + 1}/#{total_files} (#{((index + 1).to_f / total_files * 100).round(1)}%)" if (index + 1) % 10 == 0

      # Skip if already migrated
      if workfile.filesystem.exists?
        puts "  スキップ: #{workfile.filename} (ID: #{workfile.id}) - 既に移行済み"
        skipped_count += 1
        next
      end

      # Check if work has valid card_person_id
      unless workfile.work&.card_person_id
        puts "  エラー: #{workfile.filename} (ID: #{workfile.id}) - card_person_idがありません"
        error_count += 1
        next
      end

      begin
        # Migrate file from ActiveStorage to filesystem
        workfile.workdata.open do |file|
          # Ensure original filename is preserved
          if workfile.filename.blank?
            workfile.filename = workfile.workdata.filename.to_s
            workfile.save!
          end

          # Save to filesystem
          workfile.filesystem.save(file)

          # Verify migration success
          if workfile.filesystem.exists?
            filesystem_size = workfile.filesystem.size
            activestorage_size = workfile.workdata.byte_size

            if filesystem_size == activestorage_size
              puts "  移行完了: #{workfile.filename} (ID: #{workfile.id}) - #{filesystem_size} bytes"
            else
              puts "  警告: #{workfile.filename} (ID: #{workfile.id}) - サイズ不一致 AS:#{activestorage_size} FS:#{filesystem_size}"
            end
            migrated_count += 1
          else
            puts "  エラー: #{workfile.filename} (ID: #{workfile.id}) - ファイルシステムへの保存に失敗"
            error_count += 1
          end
        end
      rescue StandardError => e
        puts "  エラー: #{workfile.filename} (ID: #{workfile.id}) - #{e.message}"
        error_count += 1

        # Clean up partial file if it exists
        begin
          workfile.filesystem.delete if workfile.filesystem.exists?
        rescue StandardError => cleanup_error
          puts "    クリーンアップエラー: #{cleanup_error.message}"
        end
      end
    end

    puts
    puts '========== 移行結果 =========='
    puts "処理対象: #{total_count}件"
    puts "移行完了: #{migrated_count}件"
    puts "既に移行済み: #{skipped_count}件"
    puts "移行失敗: #{error_count}件"
    puts "移行率: #{total_count > 0 ? (migrated_count.to_f / total_count * 100).round(2) : 0}%"
    puts "時刻: #{Time.current}"
    puts

    if error_count > 0
      puts 'エラーが発生したファイルがあります。ログを確認してください。'
      exit 1
    else
      puts '移行が正常に完了しました！'
    end
  end

  desc 'Verify filesystem migration'
  task verify_migration: :environment do
    # Allow targeting specific IDs for testing
    limit = ENV['LIMIT']&.to_i || nil
    puts '検証開始: ファイルシステム移行の確認'
    puts "時刻: #{Time.current}"
    puts

    total_count = 0
    filesystem_count = 0
    activestorage_count = 0
    missing_count = 0
    size_mismatch_count = 0

    # Detailed verification results
    verification_results = {
      filesystem_only: [],
      activestorage_only: [],
      both_storage: [],
      missing_files: [],
      size_mismatches: []
    }

    # Build query with optional filters
    query = Workfile.includes(:work)

    if ENV['IDS']
      ids = ENV['IDS'].split(',').map(&:to_i)
      query = query.where(id: ids)
    elsif limit
      query = query.limit(limit)
    end

    query.find_each do |workfile|
      total_count += 1

      has_filesystem = workfile.filesystem.exists?
      has_activestorage = workfile.workdata.attached?

      if has_filesystem && has_activestorage
        # Both storage types exist - verify sizes
        filesystem_size = workfile.filesystem.size
        activestorage_size = workfile.workdata.byte_size

        if filesystem_size == activestorage_size
          verification_results[:both_storage] << {
            id: workfile.id,
            filename: workfile.filename,
            size: filesystem_size
          }
          filesystem_count += 1
        else
          verification_results[:size_mismatches] << {
            id: workfile.id,
            filename: workfile.filename,
            filesystem_size: filesystem_size,
            activestorage_size: activestorage_size
          }
          size_mismatch_count += 1
        end

      elsif has_filesystem && !has_activestorage
        verification_results[:filesystem_only] << {
          id: workfile.id,
          filename: workfile.filename,
          size: workfile.filesystem.size
        }
        filesystem_count += 1

      elsif !has_filesystem && has_activestorage
        verification_results[:activestorage_only] << {
          id: workfile.id,
          filename: workfile.filename,
          size: workfile.workdata.byte_size
        }
        activestorage_count += 1

      else
        verification_results[:missing_files] << {
          id: workfile.id,
          filename: workfile.filename
        }
        missing_count += 1
      end
    end

    puts '========== 検証結果 =========='
    puts "総ファイル数: #{total_count}"
    puts "ファイルシステムのみ: #{verification_results[:filesystem_only].size}"
    puts "ActiveStorageのみ: #{verification_results[:activestorage_only].size}"
    puts "両方存在: #{verification_results[:both_storage].size}"
    puts "ファイルなし: #{verification_results[:missing_files].size}"
    puts "サイズ不一致: #{verification_results[:size_mismatches].size}"
    puts "移行率: #{total_count > 0 ? ((filesystem_count + verification_results[:both_storage].size).to_f / total_count * 100).round(2) : 0}%"

    # Show detailed results if requested
    if ENV['DETAILED'] == 'true'
      puts
      puts '========== 詳細結果 =========='

      unless verification_results[:missing_files].empty?
        puts
        puts '--- ファイルなし ---'
        verification_results[:missing_files].each do |file|
          puts "ID: #{file[:id]}, ファイル名: #{file[:filename]}"
        end
      end

      unless verification_results[:size_mismatches].empty?
        puts
        puts '--- サイズ不一致 ---'
        verification_results[:size_mismatches].each do |file|
          puts "ID: #{file[:id]}, ファイル名: #{file[:filename]}, FS: #{file[:filesystem_size]}, AS: #{file[:activestorage_size]}"
        end
      end

      unless verification_results[:activestorage_only].empty?
        puts
        puts '--- ActiveStorageのみ（移行未完了）---'
        verification_results[:activestorage_only].first(10).each do |file|
          puts "ID: #{file[:id]}, ファイル名: #{file[:filename]}, サイズ: #{file[:size]}"
        end
        puts "... 他 #{verification_results[:activestorage_only].size - 10}件" if verification_results[:activestorage_only].size > 10
      end
    end

    puts
    puts "時刻: #{Time.current}"
    puts

    if verification_results[:missing_files].any? || verification_results[:size_mismatches].any?
      puts '問題のあるファイルが見つかりました。DETAILED=true で詳細を確認してください。'
      exit 1
    elsif verification_results[:activestorage_only].any?
      puts '移行が未完了のファイルがあります。migration:migrate_to_filesystem を実行してください。'
      exit 1
    else
      puts 'すべてのファイルが正常に移行されています！'
    end
  end

  desc 'Clean up ActiveStorage files after successful migration'
  task cleanup_activestorage: :environment do
    # Allow targeting specific IDs for testing
    limit = ENV['LIMIT']&.to_i || nil
    puts '開始: ActiveStorageファイルのクリーンアップ'
    puts "時刻: #{Time.current}"
    puts

    # Safety check
    puts '⚠️  重要: このタスクはActiveStorageファイルを削除します。'
    puts '   事前に移行の完了を確認してください: rails storage:verify_migration'
    puts

    # Confirmation in production
    if Rails.env.production?
      print '本番環境です。続行しますか？ (yes/no): '
      response = $stdin.gets.chomp
      unless response.downcase == 'yes'
        puts '中止しました。'
        exit 0
      end
    end

    cleaned_count = 0
    error_count = 0
    skipped_count = 0

    # Build query for files with both storage types
    query = Workfile.joins(:workdata_attachment).includes(:work)

    if ENV['IDS']
      ids = ENV['IDS'].split(',').map(&:to_i)
      query = query.where(id: ids)
    elsif limit
      query = query.limit(limit)
    end

    workfiles_with_both = query.select do |workfile|
      workfile.workdata.attached? && workfile.filesystem.exists?
    end

    total_files = workfiles_with_both.size
    puts "クリーンアップ対象: #{total_files}件"
    puts

    workfiles_with_both.each_with_index do |workfile, index|
      # Progress indicator
      puts "進捗: #{index + 1}/#{total_files} (#{((index + 1).to_f / total_files * 100).round(1)}%)" if (index + 1) % 10 == 0

      begin
        # Store info before deletion
        workfile_id = workfile.id
        workfile_filename = workfile.filename

        # Double-check file sizes match
        activestorage_size = workfile.workdata.byte_size
        filesystem_size = workfile.filesystem.size

        if activestorage_size == filesystem_size
          # Safe to delete ActiveStorage file
          workfile.workdata.purge
          puts "  削除完了: #{workfile_filename} (ID: #{workfile_id}) - #{filesystem_size} bytes"
          cleaned_count += 1
        else
          puts "  スキップ: #{workfile_filename} (ID: #{workfile_id}) - サイズ不一致 AS:#{activestorage_size} FS:#{filesystem_size}"
          skipped_count += 1
        end
      rescue StandardError => e
        puts "  エラー: #{begin
          workfile.filename
        rescue StandardError
          'N/A'
        end} (ID: #{begin
          workfile.id
        rescue StandardError
          'N/A'
        end}) - #{e.message}"
        error_count += 1
      end
    end

    puts
    puts '========== クリーンアップ結果 =========='
    puts "削除完了: #{cleaned_count}件"
    puts "スキップ: #{skipped_count}件"
    puts "削除失敗: #{error_count}件"
    puts "時刻: #{Time.current}"
    puts

    if error_count > 0
      puts 'エラーが発生したファイルがあります。ログを確認してください。'
      exit 1
    else
      puts 'クリーンアップが正常に完了しました！'
    end
  end

  desc 'Rollback filesystem migration (restore from ActiveStorage)'
  task rollback_migration: :environment do
    puts '開始: ファイルシステム移行のロールバック'
    puts "時刻: #{Time.current}"
    puts

    # Safety confirmation
    puts '⚠️  警告: このタスクはファイルシステムのファイルを削除します。'
    print '続行しますか？ (yes/no): '
    response = $stdin.gets.chomp
    unless response.downcase == 'yes'
      puts '中止しました。'
      exit 0
    end

    rollback_count = 0
    error_count = 0

    filesystem_files = Workfile.includes(:work).select(&:filesystem.exists?)
    total_files = filesystem_files.size

    puts "ロールバック対象: #{total_files}件"
    puts

    filesystem_files.each_with_index do |workfile, index|
      # Progress indicator
      puts "進捗: #{index + 1}/#{total_files} (#{((index + 1).to_f / total_files * 100).round(1)}%)" if (index + 1) % 10 == 0

      begin
        if workfile.workdata.attached?
          # Delete filesystem file, keep ActiveStorage
          workfile.filesystem.delete
          puts "  ロールバック完了: #{workfile.filename} (ID: #{workfile.id})"
          rollback_count += 1
        else
          puts "  スキップ: #{workfile.filename} (ID: #{workfile.id}) - ActiveStorageファイルがありません"
        end
      rescue StandardError => e
        puts "  エラー: #{workfile.filename} (ID: #{workfile.id}) - #{e.message}"
        error_count += 1
      end
    end

    puts
    puts '========== ロールバック結果 =========='
    puts "ロールバック完了: #{rollback_count}件"
    puts "ロールバック失敗: #{error_count}件"
    puts "時刻: #{Time.current}"
    puts

    if error_count > 0
      puts 'エラーが発生したファイルがあります。'
      exit 1
    else
      puts 'ロールバックが正常に完了しました！'
    end
  end
end
