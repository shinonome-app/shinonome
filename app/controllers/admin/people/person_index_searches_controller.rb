# frozen_string_literal: true

module Admin
  module People
    class PersonIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/people/person_index_searches
      def index
        char = params[:person]

        @pagy, @people = pagy(Person.with_name_firstchar(char).order(:sortkey, :sortkey2, :id), limit: 50)
      end
    end
  end
end
