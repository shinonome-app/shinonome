# frozen_string_literal: true

module Admin
  module WorkWorkers
    class TextSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/work/:work_id/work_workers/text_searches
      def index
        name = params[:name]
        text_selector_name = params[:text_selector_name].to_i

        name_kana = params[:name_kana]
        text_selector_name_kana = params[:text_selector_name_kana].to_i

        @work = Work.find(params[:work_id])

        text_searcher = ::TextSearcher.new

        text_searcher.add_query_param('name', name, text_selector_name)
        text_searcher.add_query_param('name_kana', name_kana, text_selector_name_kana)

        workers = Worker.where(text_searcher.where_params)

        @pagy, @workers = pagy(workers.order(created_at: :desc), limit: 50)
      end
    end
  end
end
