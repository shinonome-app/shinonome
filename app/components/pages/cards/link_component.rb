# frozen_string_literal: true

module Pages
  module Cards
    # 静的サイトのリンク用
    class LinkComponent < ViewComponent::Base
      attr_reader :work, :booklog_url, :voyger_url, :airzoshi_url, :rodoku_url

      def initialize(work:)
        super

        @work = work
        @booklog_url = "http://booklog.jp/item/7/#{work.id}"
        @voyger_url = "http://aozora.binb.jp/reader/main.html?cid=#{work.id}"
        @airzoshi_url = "https://www.satokazzz.com/airzoshi/reader.php?action=aozora&id=#{work.id}"
        @rodoku_url = "https://www.google.co.jp/search?hl=ja&source=hp&q=青空文庫+朗読+#{work.title}"
      end
    end
  end
end
