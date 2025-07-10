# frozen_string_literal: true

module Admin
  module Sysadmin
    class WorkfileReportersController < Admin::ApplicationController
      # GET /admin/sysadmin/workfile-reporter/new
      def new
        @days = params[:days]&.to_i || 7
        @include_details = params[:include_details] == 'true'
      end
    end
  end
end
