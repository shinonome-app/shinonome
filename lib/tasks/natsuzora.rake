# frozen_string_literal: true

# komadome-rs (Rust SSG) で primary に管理されている natsuzora テンプレート
# (templates/) と subaru 契約 (contracts/) を shinonome リポジトリ内へコピーして
# 同期させるタスク群。
#
# 設計方針:
#   - natsuzora の真の出所は komadome-rs。shinonome では Rails プレビューの
#     ためだけに同じファイルを持つ。
#   - 本番デプロイ時に shinonome 単独でも動くよう、コピー実体を git 追跡する。
#   - 開発時は `bin/rails natsuzora:sync` で同期。CI などで `bin/rails
#     natsuzora:check` を回せば drift を検知できる。
namespace :natsuzora do
  # __dir__ = shinonome/lib/tasks/ なので 3 階層上が aozora/、その下に komadome-rs/。
  KOMADOME_RS_ROOT = File.expand_path('../../../komadome-rs', __dir__).freeze
  SUBDIRS = %w[templates contracts].freeze

  desc 'Sync natsuzora templates and contracts from komadome-rs'
  task :sync do
    require 'fileutils'

    SUBDIRS.each do |subdir|
      src = File.join(KOMADOME_RS_ROOT, subdir)
      dest = Rails.root.join(subdir).to_s

      unless Dir.exist?(src)
        warn "skip: #{src} does not exist"
        next
      end

      FileUtils.rm_rf(dest)
      FileUtils.mkdir_p(dest)
      FileUtils.cp_r(File.join(src, '.'), dest)
      puts "synced: #{src} -> #{dest}"
    end
  end

  desc 'Check that local natsuzora templates/contracts match komadome-rs (exit 1 on drift)'
  task :check do
    require 'fileutils'
    require 'open3'

    drifted = false
    SUBDIRS.each do |subdir|
      src = File.join(KOMADOME_RS_ROOT, subdir)
      dest = Rails.root.join(subdir).to_s

      unless Dir.exist?(src)
        warn "skip: #{src} does not exist"
        next
      end

      output, status = Open3.capture2('diff', '-rq', src, dest)
      if status.success?
        puts "ok: #{subdir} is in sync"
      else
        drifted = true
        puts "DRIFT detected in #{subdir}:"
        puts output
      end
    end

    if drifted
      warn "\nRun `bin/rails natsuzora:sync` to update."
      exit 1
    end
  end
end
