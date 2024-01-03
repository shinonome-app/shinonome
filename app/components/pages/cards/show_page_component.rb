# frozen_string_literal: true

module Pages
  module Cards
    class ShowPageComponent < ViewComponent::Base
      attr_reader :work, :booklog_url, :voyger_url, :airzoshi_url, :rodoku_url

      def initialize(card_id:, person_id:)
        super

        @work = Work.joins(:work_people).where('works.id = ? AND work_people.person_id = ?', card_id, person_id).first
        @booklog_url = "http://booklog.jp/item/7/#{@work.id}"
        @voyger_url = "http://aozora.binb.jp/reader/main.html?cid=#{@work.id}"
        @airzoshi_url = "https://www.satokazzz.com/airzoshi/reader.php?action=aozora&id=#{@work.id}"
        @rodoku_url = "https://www.google.co.jp/search?hl=ja&source=hp&q=青空文庫+朗読+#{@work.title}"
      end
    end
  end
end
