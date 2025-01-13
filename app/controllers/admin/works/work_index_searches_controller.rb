# frozen_string_literal: true

module Admin
  module Works
    class WorkIndexSearchesController < ::Admin::ApplicationController
      include Pagy::Backend

      # GET /admin/works/work_index_searches
      def index
        char = params[:work]

        @pagy, @works = pagy(Work.includes(
          :work_people,
          :people,
          :kana_type,
          :work_status
        ).with_title_firstchar(char).order(created_at: :desc), limit: 50)
      end
    end
  end
end
