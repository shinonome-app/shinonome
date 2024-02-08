# frozen_string_literal: true

module Admin
  module Typesettings
    class ResultsController < Admin::ApplicationController
      # GET /admin/typesettings/1/results
      def index
        @typesetting = Typesetting.find(params[:typesetting_id])

        render file: @typesetting.file_path, layout: false, content_type: 'text/html;charset=Shift_JIS'
      end
    end
  end
end
