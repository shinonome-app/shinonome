# frozen_string_literal: true

# 公開サイト(komadome-rs)の「ビルドのみ」を要求するサービス。
# web コンテナと komadome-rs コンテナで共有するディレクトリ（KOMADOME_CONTROL_DIR）に
# build.request を書き、komadome-rs 側の check-and-build.sh が毎分拾って run-build.sh を実行する。
# 結果は build.status に書き戻される（running / done / failed）。
class SiteBuildRequester
  CONTROL_DIR = ENV.fetch('KOMADOME_CONTROL_DIR', '/rails/komadome_control')

  Status = Data.define(:state, :at, :pages)

  # ビルドを要求する（request ファイルを作成）。成功で true。
  def request!
    FileUtils.mkdir_p(CONTROL_DIR)
    FileUtils.touch(request_path)
    true
  rescue SystemCallError => e
    Rails.logger.error("SiteBuildRequester#request! failed: #{e.message}")
    false
  end

  # 直近のビルド状態。未実行なら nil。
  def status
    raw = File.read(status_path).strip
    state, at, *rest = raw.split("\t")
    pages = rest.find { |s| s.start_with?('pages=') }&.delete_prefix('pages=')
    Status.new(state:, at:, pages:)
  rescue SystemCallError
    nil
  end

  # 要求がまだ消費されていない（ビルド待ち or 実行待ち）か。
  def pending?
    File.exist?(request_path)
  rescue SystemCallError
    false
  end

  private

  def request_path = File.join(CONTROL_DIR, 'build.request')
  def status_path = File.join(CONTROL_DIR, 'build.status')
end
