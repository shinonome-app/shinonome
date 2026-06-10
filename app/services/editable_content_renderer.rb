# frozen_string_literal: true

# EditableContent の natsuzora フラグメントを描画する。
# include_root を渡さないため、フラグメント内の {[!include]} は使用できない
# （komadome-rs 側の Natsuzora::parse と意味論を揃えるための制約）。
class EditableContentRenderer
  def initialize(area_name:, key:)
    @area_name = area_name
    @key = key
  end

  # 厳格: Natsuzora::Error をそのまま投げる（プレビュー・公開時検証用）
  def render(source, context)
    Natsuzora.render(source, context)
  end

  # 寛容: 最新の公開済みコンテンツを描画する。
  # 公開行なし・空・描画エラー時は '' を返し、テンプレート側の
  # デフォルトボディ（/top/body）へのフォールバックに任せる（本番用）。
  def render_published(context)
    source = EditableContent.latest_published_for(@area_name, @key)&.value
    return '' if source.blank?

    render(source, context)
  rescue Natsuzora::Error => e
    Rails.logger.error("EditableContentRenderer: #{@area_name}/#{@key} の描画に失敗したためフォールバックします: #{e.message}")
    ''
  end
end
