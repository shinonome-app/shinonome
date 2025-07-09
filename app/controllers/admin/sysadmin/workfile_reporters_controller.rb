# frozen_string_literal: true

module Admin
  module Sysadmin
    class WorkfileReportersController < Admin::ApplicationController
      # GET /admin/sysadmin/workfile-reporter/new
      def new
        @days = params[:days]&.to_i || 7
        @include_details = params[:include_details] == 'true'
      end

      # POST /admin/sysadmin/workfile-reporter
      def create
        @days = params[:days]&.to_i || 7
        @include_details = params[:include_details] == 'true'

        begin
          @reporter = WorkfileReporter.new(days: @days, include_details: @include_details)
          @result = @reporter.generate_report
          @workfiles = @reporter.workfiles

          render :show
        rescue StandardError => e
          Rails.logger.error "WorkfileReporter error: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")

          flash.now[:alert] = "レポート生成中にエラーが発生しました: #{e.message}"
          render :new, status: :unprocessable_entity
        end
      end

      private

      def workfile_reporter_params
        params.permit(:days, :include_details)
      end
    end
  end
end
