# frozen_string_literal: true

module NatsuzoraContext
  # Builds the context hash for top/index.ntzr (トップページ).
  class TopBuilder
    # 「歩みの記録」(topics) に出す最新件数
    TOPICS_LIMIT = 10

    # editable_content_source を渡すと、その natsuzora フラグメントを厳格に
    # 描画する（不正なら Natsuzora::Error）。空文字なら「コンテンツなし」
    # として扱う（テンプレート側でデフォルトボディにフォールバック）。
    # 省略（nil）時は最新の公開済み EditableContent を寛容に描画する
    # （不正なら '' フォールバック）。
    def build(editable_content_source: nil)
      context = build_base_context
      html =
        if editable_content_source.nil?
          EditableContentRenderer.new(area_name: 'top', key: 'main').render_published(context)
        elsif editable_content_source.present?
          EditableContentRenderer.new(area_name: 'top', key: 'main').render(editable_content_source, context)
        else
          ''
        end
      context.merge('editable_content_html' => html)
    end

    private

    def build_base_context
      new_works, new_works_published_on = fetch_new_works
      latest_news_entry = NewsEntry.published.order(published_on: :desc).first
      topics = NewsEntry.topics.order(published_on: :desc).limit(TOPICS_LIMIT)

      {
        'page_title' => '青空文庫',
        'bgcolor' => 'bg-white-100',
        'new_works' => new_works.map { |w| build_new_work(w) },
        'new_works_published_on' => new_works_published_on.to_s,
        'latest_news_published_on' => latest_news_entry&.published_on.to_s,
        'topics' => topics.map { |t| build_topic(t) },
        'works_count' => Work.published.count,
        'works_copyright_count' => Work.copyrighted_count,
        'works_noncopyright_count' => Work.non_copyrighted_count,
        'editable_content_html' => ''
      }
    end

    def fetch_new_works
      works = Work.latest_published
      works = Work.latest_published(year: Time.zone.now.year - 1) if works.blank?

      latest = works.order(started_on: :desc).first
      if latest.present?
        published_on = latest.started_on
        new_works = works.where(started_on: published_on).order(id: :asc)
        [new_works, published_on]
      else
        [Work.none, nil]
      end
    end

    def build_new_work(work)
      card_person_dir = work.card_person_id || ''
      {
        'work_id' => work.id,
        'title' => work.title,
        'subtitle' => work.subtitle.to_s,
        'author_text' => work.author_text,
        'card_person_dir' => card_person_dir
      }
    end

    def build_topic(topic)
      {
        'id' => topic.id,
        'anchor' => topic.anchor,
        'title' => topic.title,
        'published_on' => topic.published_on.to_s,
        'year' => topic.published_on&.year || 0
      }
    end
  end
end
