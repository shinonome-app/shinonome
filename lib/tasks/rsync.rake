# frozen_string_literal: true

namespace :rsync do
  desc 'Setup RSYNC key from environment variable'
  task setup_key: :environment do
    require_relative '../../scripts/setup_rsync_key'
    RsyncKeySetup.new.setup
  end

  desc 'Test RSYNC connection'
  task test_connection: :environment do
    key_file = '/rails/data/.ssh/rsync.key'

    unless File.exist?(key_file)
      puts 'エラー: 鍵ファイルが見つかりません。先に rake rsync:setup_key を実行してください。'
      exit 1
    end

    host = ENV['RSYNC_HOST'] || 'example.com'
    user = ENV['RSYNC_USER'] || 'rsync'

    puts 'RSYNC接続テスト...'
    puts "Host: #{host}"
    puts "User: #{user}"
    puts "Key: #{key_file}"

    # SSH接続テスト
    if system("ssh -i #{key_file} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null #{user}@#{host} 'echo Connection successful'")
      puts '✅ 接続成功！'
    else
      puts '❌ 接続失敗'
      exit 1
    end
  end

  desc 'Transfer recently published workfiles'
  task :transfer_workfiles, [:past_days, :future_days] => :environment do |_t, args|
    past_days = args[:past_days]&.to_i || 3
    future_days = args[:future_days]&.to_i || 0

    puts '=== Workfile転送 ==='
    puts "対象期間: 過去#{past_days}日 〜 #{future_days > 0 ? "未来#{future_days}日" : '今日'}"
    puts

    transferer = WorkfileTransferer.new(past_days: past_days, future_days: future_days)

    # 対象ファイルの確認
    works = transferer.send(:recent_published_works)
    puts "対象作品数: #{works.count}"

    if works.any?
      puts "\n対象作品:"
      works.each do |work|
        puts "- #{work.title} (ID: #{work.id}, 公開日: #{work.started_on})"
        work.workfiles.each do |wf|
          puts "  - #{wf.filename}"
        end
      end

      puts "\n転送を開始しますか？ (y/N)"
      if $stdin.gets.chomp.downcase == 'y'
        transferer.transfer_files
        puts '✅ 転送完了'
      else
        puts '転送をキャンセルしました'
      end
    else
      puts '転送対象のファイルがありません'
    end
  end

  desc 'List workfiles to be transferred (dry-run)'
  task :list_workfiles, [:past_days, :future_days] => :environment do |_t, args|
    past_days = args[:past_days]&.to_i || 3
    future_days = args[:future_days]&.to_i || 0

    transferer = WorkfileTransferer.new(past_days: past_days, future_days: future_days)
    file_list = '/tmp/workfile_paths.txt'

    transferer.output_paths(file_list)

    if File.exist?(file_list)
      puts '転送対象ファイル:'
      puts File.read(file_list).gsub(';', "\n")
      File.delete(file_list)
    else
      puts '転送対象のファイルがありません'
    end
  end
end
