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
          link_to(news_entry.published_on, admin_news_entry_path(news_entry), class: 'underline'),
          safe_join([news_entry.title, tag.br, truncate(news_entry.body, length: 40)]),
          news_entry.flag ? '○' : '-',
          button_to('削除', [:admin, news_entry], method: :delete, form: { data: { turbo_confirm: '本当に削除しますか?' } }, class: delete_button_class)
        ]
      end
    end
  end
end
