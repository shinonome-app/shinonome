# frozen_string_literal: true

module Pages
  module Top
    # トップページ
    class IndexPageComponent < ViewComponent::Base
      attr_reader :new_works, :new_works_published_on, :latest_news_entry, :topics, :works_count, :works_copyright_count, :works_noncopyright_count

      def initialize
        super

        if Work.latest_published.blank?
          @new_works_published_on = Work.latest_published(year: Time.zone.now.year - 1).order(started_on: :desc).first.started_on
          @new_works = Work.latest_published(year: Time.zone.now.year - 1).where(started_on: new_works_published_on).order(id: :asc)
        else
          @new_works_published_on = Work.latest_published.order(started_on: :desc).first.started_on
          @new_works = Work.latest_published.where(started_on: new_works_published_on).order(id: :asc)
        end
        @latest_news_entry = NewsEntry.published.order(published_on: :desc).first
        @topics = NewsEntry.topics.order(published_on: :desc)

        @works_count = Work.published.count
        @works_copyright_count = Work.copyrighted_count
        @works_noncopyright_count = Work.non_copyrighted_count
      end

      private

      def render_editable_content
        local_vars = {
          new_works:,
          new_works_published_on:,
          latest_news_entry:,
          topics:,
          works_count:,
          works_copyright_count:,
          works_noncopyright_count:
        }

        area_name = 'top'
        key = 'main'
        erb_content = EditableContent.latest_for(area_name, key).value

        evaluate_with_context(erb_content, local_vars)
      end

      def evaluate_with_context(erb_content, local_vars)
        local_vars.each do |key, value|
          view_context.instance_variable_set(:"@#{key}", value)
          view_context.define_singleton_method(key) { value }
        end

        view_context.instance_eval do
          ERB.new(erb_content).result(binding)
        end
      end
    end
  end
end
