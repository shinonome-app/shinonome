# frozen_string_literal: true

module Admin
  module People
    class PersonIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/people/person_index_searches
      def index
        char = params[:person]
        scope = Person.with_name_firstchar(char).order(:sortkey, :sortkey2, :id)

        @show_all = params[:all].present?
        limit = @show_all ? [scope.count, 1].max : LIST_LIMIT
        @pagy, @people = pagy(scope, limit:)
      end
    end
  end
end
