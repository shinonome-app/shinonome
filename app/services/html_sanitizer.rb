# frozen_string_literal: true

# DB に保存された HTML 断片を許可リスト方式で sanitize する。管理画面の表示（ApplicationHelper#safe_html）で使う。
#
# 作品の備考などは管理者が HTML で書く前提で、公開サイト（komadome-rs）や図書カードのプレビューでは
# sanitize せずにそのまま出力する。信頼できない入力は、公開フォームの側で受け付けない（ReceiptForm::SubWork）。
#
# 許可するタグ・属性は、既存データ（作品・人物・お知らせ・非公開メモ）で実際に使われているもの
# （a, br, img, i, em, blockquote, s, font, h2 など）に、無害な書式タグを加えたもの。
# 許可しないタグはタグだけを外して中身を残す。ただし script や style などは中身ごと削除する。
# href/src のスキームは Rails の sanitizer が検査する（http, https, mailto, 相対パス等のみ通る）。
class HtmlSanitizer
  ALLOWED_TAGS = %w[
    a abbr b blockquote br caption cite code col colgroup dd div dl dt em font h1 h2 h3 h4 h5 h6 hr i img li ol p
    pre q s small span strong sub sup table tbody td tfoot th thead tr u ul
  ].freeze

  ALLOWED_ATTRIBUTES = %w[
    href target rel src alt title width height align valign border class color colspan rowspan
  ].freeze

  # 中身もテキストとして表示すべきでない要素
  PRUNED_TAGS = %w[script style noscript template iframe object embed title textarea].freeze

  # 許可しないタグのうち PRUNED_TAGS だけを中身ごと削除する scrubber
  class Scrubber < Rails::HTML::PermitScrubber
    def initialize
      super
      self.tags = ALLOWED_TAGS
      self.attributes = ALLOWED_ATTRIBUTES
    end

    protected

    def scrub_node(node)
      return super unless PRUNED_TAGS.include?(node.name)

      node.remove
      STOP
    end
  end

  def sanitize(text)
    return '' if text.blank?

    sanitizer.sanitize(text.to_s, scrubber: Scrubber.new)
  end

  private

  def sanitizer
    @sanitizer ||= Rails::HTML5::SafeListSanitizer.new
  end
end
