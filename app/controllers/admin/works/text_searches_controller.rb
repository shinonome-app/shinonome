# frozen_string_literal: true

module Admin
  module Works
    class TextSearchesController < ApplicationController
      include Pagy::Backend

      # GET /admin/works/text_searches
      def index
        title = params[:title]
        text_selector_title = params[:text_selector_title].to_i
        title_kana = params[:title_kana]
        text_selector_title_kana = params[:text_selector_title_kana].to_i

        subtitle = params[:subtitle]
        text_selector_subtitle = params[:text_selector_subtitle].to_i
        subtitle_kana = params[:subtitle_kana]
        text_selector_subtitle_kana = params[:text_selector_subtitle_kana].to_i

        collection = params[:collection]
        text_selector_collection = params[:text_selector_collection].to_i
        collection_kana = params[:collection_kana]
        text_selector_collection_kana = params[:text_selector_collection_kana].to_i

        original_title = params[:original_title]
        text_selector_original_title = params[:text_selector_original_title].to_i

        description = params[:description]
        text_selector_description = params[:text_selector_description].to_i

        text_searcher = ::TextSearcher.new

        text_searcher.add_query_param('title', title, text_selector_title)
        text_searcher.add_query_param('title_kana', title_kana, text_selector_title_kana)
        text_searcher.add_query_param('subtitle', subtitle, text_selector_subtitle)
        text_searcher.add_query_param('subtitle_kana', subtitle_kana, text_selector_subtitle_kana)
        text_searcher.add_query_param('collection', collection, text_selector_collection)
        text_searcher.add_query_param('collection_kana', collection_kana, text_selector_collection_kana)
        text_searcher.add_query_param('original_title', original_title, text_selector_original_title)
        text_searcher.add_query_param('description', description, text_selector_description)

        works = text_searcher.apply_to(
          Work.includes(
            :work_people,
            :people,
            :kana_type,
            :work_status
          )
        )

        @pagy, @works = pagy(works.order(created_at: :desc), limit: 50)
      end
    end
  end
end
