# frozen_string_literal: true

module Admin
  module BasePeople
    class TextSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/people/:person_id/base_people/text_searches
      def index
        last_name = params[:last_name]
        text_selector_last_name = params[:text_selector_last_name].to_i
        last_name_kana = params[:last_name_kana]
        text_selector_last_name_kana = params[:text_selector_last_name_kana].to_i

        first_name = params[:first_name]
        text_selector_first_name = params[:text_selector_first_name].to_i
        first_name_kana = params[:first_name_kana]
        text_selector_first_name_kana = params[:text_selector_first_name_kana].to_i

        @person = Person.find(params[:person_id])

        text_searcher = ::TextSearcher.new

        text_searcher.add_query_param('first_name', first_name, text_selector_first_name)
        text_searcher.add_query_param('first_name_kana', first_name_kana, text_selector_first_name_kana)
        text_searcher.add_query_param('last_name', last_name, text_selector_last_name)
        text_searcher.add_query_param('last_name_kana', last_name_kana, text_selector_last_name_kana)

        people = Person.where(text_searcher.where_params)

        @pagy, @people = pagy(people.order(created_at: :desc), limit: 50)
      end
    end
  end
end
