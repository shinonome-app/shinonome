# frozen_string_literal: true

require 'English'

# komadome / komadome-rs の parity check (dev-db モード) 用に、
# 公開対象データのみを含む data-only dump を生成する。
#
# 設計の前提（重要）:
#   - komadome が読むのは公開サイトに出るデータのみ。機密は *_secrets と
#     shinonome スキーマ、および shinonome 内部テーブル(proofreads/receipts 等)に隔離されている。
#   - work_status_id が公開対象(1=公開, 3..11=作業中として公開)以外の作品は
#     公開サイトに出ないため、public な dump には含めてはならない。
#   - 出力した dump は public リポジトリ(komadome-parity-data 等)にコミットする想定。
#
# 安全策: 一時DBへコピーした上で「機密テーブルを TRUNCATE」「非公開 work と従属行を DELETE」
# してから dump する。dump 側のフィルタに頼らず、データ自体を消し切る fail-safe 方式。
#
# 使い方:
#   bin/rails parity:export_dump                       # 接続中のDBから生成
#   PARITY_DUMP_OUT=/path/parity_dump.sql.gz bin/rails parity:export_dump
#
# 必要権限: 接続ユーザに CREATEDB 権限が必要(一時DBの作成のため)。

namespace :parity do
  desc '公開対象データのみの parity 用 data-only dump を生成する'
  task export_dump: :environment do
    # komadome が公開ページ/作業中ページとして出力する work_status_id。
    # 1=公開, 3..11=入力中〜翻訳中(作業中として公開)。
    # 2=非公開, 12..15(入力取り消し/校了(点検前)/校正受領/公開保留)は公開対象外。
    public_status_ids = [1, 3, 4, 5, 6, 7, 8, 9, 10, 11]

    # komadome が読まない、機密/内部テーブル。temp DB 上で TRUNCATE して空にする。
    # (*_secrets は実行時に information_schema から動的に追加する)
    base_sensitive_tables = %w[
      proofreads receipts typesettings users
      active_storage_attachments active_storage_blobs active_storage_variant_records
    ]

    # 非公開 work を消す前に DELETE が必要な、works を参照する従属テーブル。
    work_dependent_tables = %w[work_people work_workers work_sites workfiles original_books]

    out_path = ENV.fetch('PARITY_DUMP_OUT', Rails.root.join('tmp/parity_dump.sql.gz').to_s)
    tmp_db   = ENV.fetch('PARITY_TMP_DB', 'parity_export_tmp')

    db = ActiveRecord::Base.connection_db_config.configuration_hash
    src_db = db.fetch(:database)
    env = {
      'PGHOST' => db[:host].to_s,
      'PGPORT' => db[:port].to_s,
      'PGUSER' => db[:username].to_s,
      'PGPASSWORD' => db[:password].to_s
    }.compact_blank

    sh_env = ->(cmd) { system(env, *cmd) || abort("command failed: #{cmd.join(' ')}") }

    puts "[parity] source=#{src_db} -> tmp=#{tmp_db} -> #{out_path}"

    # 既存の一時DBを掃除して作り直し
    system(env, 'dropdb', '--if-exists', tmp_db)
    sh_env.call(['createdb', tmp_db])

    begin
      # 1) ソースDBを一時DBへ丸ごとコピー(custom format をパイプで復元)
      puts '[parity] cloning source database...'
      dump = IO.popen(env, ['pg_dump', '-Fc', '--no-owner', '--no-privileges', src_db])
      restore = IO.popen(env, ['pg_restore', '--no-owner', '--no-privileges', '-d', tmp_db], 'wb')
      IO.copy_stream(dump, restore)
      dump.close
      restore.close
      abort('pg_dump/pg_restore failed') unless $CHILD_STATUS.success?

      # 2) 一時DB上で機密/非公開データを削除
      sensitive = (base_sensitive_tables + secret_table_names(env, tmp_db)).uniq
      status_csv = public_status_ids.join(',')
      dep_deletes = work_dependent_tables.map do |t|
        %(DELETE FROM #{t} WHERE work_id NOT IN (SELECT id FROM works WHERE work_status_id IN (#{status_csv}));)
      end

      cleanup_sql = <<~SQL.squish
        BEGIN;
        DROP SCHEMA IF EXISTS shinonome CASCADE;
        #{sensitive.map { |t| "TRUNCATE TABLE #{t} CASCADE;" }.join("\n")}
        #{dep_deletes.join("\n")}
        DELETE FROM works WHERE work_status_id NOT IN (#{status_csv});
        COMMIT;
      SQL

      puts "[parity] sanitizing (truncate #{sensitive.size} tables, keep statuses #{status_csv})..."
      sh_env.call(['psql', '-v', 'ON_ERROR_STOP=1', '-q', '-d', tmp_db, '-c', cleanup_sql])

      # 3) sanitize 済み一時DBを data-only で dump して gzip
      puts '[parity] dumping sanitized data...'
      require 'zlib'
      FileUtils.mkdir_p(File.dirname(out_path))
      reader = IO.popen(env, ['pg_dump', '--data-only', '--no-owner', '--disable-triggers',
                              '--exclude-schema=shinonome', tmp_db])
      Zlib::GzipWriter.open(out_path) { |gz| IO.copy_stream(reader, gz) }
      reader.close
      abort('pg_dump (data-only) failed') unless $CHILD_STATUS.success?

      puts "[parity] wrote #{out_path} (#{File.size(out_path)} bytes)"
    ensure
      system(env, 'dropdb', '--if-exists', tmp_db)
    end
  end

  # public スキーマ内の *_secrets テーブル名を取得する
  def secret_table_names(env, db)
    sql = "SELECT tablename FROM pg_tables WHERE schemaname='public' AND tablename LIKE '%\\_secrets';"
    out = IO.popen(env, ['psql', '-At', '-d', db, '-c', sql], &:read)
    out.to_s.split("\n").map(&:strip).reject(&:empty?)
  end
end
