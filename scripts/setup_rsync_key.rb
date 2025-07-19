#!/usr/bin/env ruby

# setup_rsync_key.rb - コンテナ内でRSYNC_PASS_FILE環境変数から鍵ファイルを設定
# Usage: bin/rails runner scripts/setup_rsync_key.rb

require 'fileutils'
require 'logger'

class RsyncKeySetup
  SSH_DIR = '/rails/data/.ssh'
  KEY_FILE = "#{SSH_DIR}/rsync.key"
  
  def initialize
    @logger = Logger.new(STDOUT)
    @logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
  end

  def setup
    @logger.info "=== RSYNC鍵ファイルセットアップ ==="
    
    # 環境変数の確認
    rsync_key_content = ENV['RSYNC_PASS_FILE']
    if rsync_key_content.nil? || rsync_key_content.empty?
      @logger.error "エラー: RSYNC_PASS_FILE環境変数が設定されていません"
      exit 1
    end
    
    @logger.info "RSYNC_PASS_FILE環境変数を検出しました"
    
    # ディレクトリの作成
    FileUtils.mkdir_p(SSH_DIR, mode: 0700)
    @logger.info "ディレクトリを作成しました: #{SSH_DIR}"
    
    # 改行文字の復元
    key_content = rsync_key_content.gsub('@NL@', "\n")
    
    # 鍵ファイルの作成
    File.write(KEY_FILE, key_content)
    File.chmod(0600, KEY_FILE)
    @logger.info "鍵ファイルを作成しました: #{KEY_FILE}"
    
    # 所有者の確認（コンテナ内では通常railsユーザー）
    uid = Process.uid
    gid = Process.gid
    File.chown(uid, gid, KEY_FILE)
    File.chown(uid, gid, SSH_DIR)
    
    # SSH設定ファイルの作成（必要に応じて）
    ssh_config = "#{SSH_DIR}/config"
    unless File.exist?(ssh_config)
      config_content = <<~CONFIG
        Host rsync-server
          HostName #{ENV['RSYNC_HOST'] || 'example.com'}
          User #{ENV['RSYNC_USER'] || 'rsync'}
          IdentityFile #{KEY_FILE}
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
      CONFIG
      
      File.write(ssh_config, config_content)
      File.chmod(0600, ssh_config)
      @logger.info "SSH設定ファイルを作成しました: #{ssh_config}"
    end
    
    # 鍵の検証
    if system("ssh-keygen -y -f #{KEY_FILE} > /dev/null 2>&1")
      @logger.info "✅ 鍵ファイルの検証に成功しました"
    else
      @logger.error "❌ 鍵ファイルの検証に失敗しました"
      exit 1
    end
    
    @logger.info ""
    @logger.info "セットアップ完了！"
    @logger.info "WorkfileTransfererサービスでrsyncが使用できるようになりました。"
    
  rescue StandardError => e
    @logger.error "エラーが発生しました: #{e.message}"
    @logger.error e.backtrace.join("\n")
    exit 1
  end
end

# メイン実行
if __FILE__ == $0
  RsyncKeySetup.new.setup
end