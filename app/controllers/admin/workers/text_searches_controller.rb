# frozen_string_literal: true

module Admin
  module Workers
    class TextSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/workers/text_searches
      def index
        name = params[:name]
        text_selector_name = params[:text_selector_name].to_i
        name_kana = params[:name_kana]
        text_selector_name_kana = params[:text_selector_name_kana].to_i

        text_searcher = ::TextSearcher.new

        text_searcher.add_query_param('name', name, text_selector_name) if name.present?
        text_searcher.add_query_param('name_kana', name_kana, text_selector_name_kana) if name_kana.present?

        workers = Worker.where(text_searcher.where_params)

        @pagy, @workers = pagy(workers.order(created_at: :desc), items: 50)
      end
    end
  end
end
