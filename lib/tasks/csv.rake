# frozen_string_literal: true

# CSV / ZIP 生成タスク
#
# komadome-rs の `generate-zip` と対応し、同一の DB から同一の CSV zip を
# 生成できるようにする。
#
# Usage:
#   bundle exec rails csv:create                    # デフォルトディレクトリ
#   bundle exec rails csv:create[/path/to/csv_dir]  # 指定ディレクトリ
#   CSV_DIR=/path/to/csv_dir bundle exec rails csv:create  # 環境変数

namespace :csv do
  desc 'Create CSV zip files (list_person_all, list_person_all_extended, list_inp_person_all)'
  task :create, [:dir] => :environment do |_task, args|
    require 'fileutils'

    # 出力ディレクトリを決定: 引数 > 環境変数 > 設定 > デフォルト
    csv_dir = args[:dir]&.to_s
    csv_dir ||= ENV.fetch('CSV_DIR', nil)
    csv_dir ||= Rails.application.config.x.csv_dir
    csv_dir ||= Rails.root.join('data/csv_zip').to_s

    FileUtils.mkdir_p(csv_dir)

    puts "Generating CSV zip files in #{csv_dir}..."

    creator = CsvCreator.new

    # 公開作品（基本）
    finished_zip = File.join(csv_dir, 'list_person_all.zip')
    creator.create_finished_zip(filename: finished_zip)
    puts "  -> #{File.basename(finished_zip)}"
    puts "  -> #{File.basename(finished_zip.sub('.zip', '_utf8.zip'))}"

    # 公開作品（拡充）
    extended_zip = File.join(csv_dir, 'list_person_all_extended.zip')
    creator.create_extended_zip(filename: extended_zip)
    puts "  -> #{File.basename(extended_zip)}"
    puts "  -> #{File.basename(extended_zip.sub('.zip', '_utf8.zip'))}"

    # 未公開作品（基本）
    unfinished_zip = File.join(csv_dir, 'list_inp_person_all.zip')
    creator.create_unfinished_zip(filename: unfinished_zip)
    puts "  -> #{File.basename(unfinished_zip)}"
    puts "  -> #{File.basename(unfinished_zip.sub('.zip', '_utf8.zip'))}"

    puts "Done. 6 zip files created in #{csv_dir}."
  end

  desc 'Clean CSV zip files'
  task clean: :environment do
    csv_dir = ENV.fetch('CSV_DIR', nil)
    csv_dir ||= Rails.application.config.x.csv_dir
    csv_dir ||= Rails.root.join('data/csv_zip').to_s

    patterns = %w[
      list_person_all.zip
      list_person_all_utf8.zip
      list_person_all_extended.zip
      list_person_all_extended_utf8.zip
      list_inp_person_all.zip
      list_inp_person_all_utf8.zip
    ]

    cleaned = 0
    patterns.each do |pattern|
      path = File.join(csv_dir, pattern)
      next unless File.exist?(path)

      File.delete(path)
      puts "  removed: #{pattern}"
      cleaned += 1
    end

    puts "Cleaned #{cleaned} files."
  end
end
