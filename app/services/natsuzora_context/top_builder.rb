# frozen_string_literal: true

module NatsuzoraContext
  # Builds the context hash for top/index.ntzr (トップページ).
  class TopBuilder
    def build
      new_works, new_works_published_on = fetch_new_works
      latest_news_entry = NewsEntry.published.order(published_on: :desc).first
      topics = NewsEntry.topics.order(published_on: :desc)

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

    private

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
        'title' => topic.title,
        'published_on' => topic.published_on.to_s,
        'year' => topic.published_on&.year || 0
      }
    end
  end
end
