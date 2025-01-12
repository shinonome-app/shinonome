# frozen_string_literal: true

module Admin
  module WorkSites
    class TextSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/people/:work_id/work_sites/text_searches
      def index
        name = params[:name]
        text_selector_name = params[:text_selector_name].to_i
        url = params[:url]
        text_selector_url = params[:text_selector_url].to_i
        owner_name = params[:owner_name]
        text_selector_owner_name = params[:text_selector_owner_name].to_i

        @work = Work.find(params[:work_id])

        text_searcher = ::TextSearcher.new

        text_searcher.add_query_param('name', name, text_selector_name)
        text_searcher.add_query_param('url', url, text_selector_url)
        text_searcher.add_query_param('owner_name', owner_name, text_selector_owner_name)

        sites = Site.where(text_searcher.where_params)

        @pagy, @sites = pagy(sites.order(created_at: :desc), limit: 50)
      end
    end
  end
end
