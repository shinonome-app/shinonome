# frozen_string_literal: true

module Admin
  # 縦表用コンポーネント
  class NewsEntriesTableComponent < ViewComponent::Base
    include TailwindHelper
    include ::Pagy::Frontend

    def initialize(news_entries:, pagy:)
      super
      @news_entries = news_entries
      @pagy = pagy
    end

    def before_render
      @header = ['日付', '見出し・本文', safe_join(['トピック', tag.br, '指定']), '']
      @body = @news_entries.map do |news_entry|
        [
          link_to(news_entry.published_on, admin_news_entry_path(news_entry)),
          safe_join([news_entry.title, tag.br, truncate(news_entry.body, length: 40)]),
          news_entry.flag ? '○' : '-',
          render(Admin::DeleteButtonComponent.new(url: admin_news_entry_path(news_entry)))
        ]
      end
    end
  end
end
