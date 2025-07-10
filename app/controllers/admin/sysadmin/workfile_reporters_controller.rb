# frozen_string_literal: true

module Admin
  module Sysadmin
    class WorkfileReportersController < Admin::ApplicationController
      # GET /admin/sysadmin/workfile_reporters/new
      def new
        @past_days = params[:past_days]&.to_i || 7
        @future_days = params[:future_days]&.to_i || 7
      end
    end
  end
end
