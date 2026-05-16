# frozen_string_literal: true

module Admin
  module TopPageContents
    class PreviewsController < Admin::ApplicationController
      layout false

      def create
        context = NatsuzoraContext::TopBuilder.new.build
        erb_content = content_params[:value].to_s

        context['editable_content_html'] = evaluate_editable_erb(erb_content) if erb_content.present?

        html = NatsuzoraRenderer.new.render('top/index.ntzr', context)
        render html: html.html_safe # rubocop:disable Rails/OutputSafety
      end

      private

      def content_params
        params.fetch(:editable_content, {}).permit(:value)
      end

      def evaluate_editable_erb(erb_content)
        new_works, new_works_published_on = fetch_new_works
        local_vars = {
          new_works: new_works,
          new_works_published_on: new_works_published_on,
          latest_news_entry: NewsEntry.published.order(published_on: :desc).first,
          topics: NewsEntry.topics.order(published_on: :desc),
          works_count: Work.published.count,
          works_copyright_count: Work.copyrighted_count,
          works_noncopyright_count: Work.non_copyrighted_count
        }

        local_vars.each do |key, value|
          view_context.instance_variable_set(:"@#{key}", value)
          view_context.define_singleton_method(key) { value }
        end

        view_context.instance_eval do
          ERB.new(erb_content).result(binding)
        end
      end

      def fetch_new_works
        works = Work.latest_published
        works = Work.latest_published(year: Time.zone.now.year - 1) if works.blank?

        latest = works.order(started_on: :desc).first
        if latest.present?
          published_on = latest.started_on
          [works.where(started_on: published_on).order(id: :asc), published_on]
        else
          [Work.none, nil]
        end
      end
    end
  end
end
