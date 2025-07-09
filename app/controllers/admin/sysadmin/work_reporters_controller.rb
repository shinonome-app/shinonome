# frozen_string_literal: true

module Admin
  module Sysadmin
    class WorkReportersController < Admin::ApplicationController
      # GET /admin/sysadmin/work_reporters/new
      def new
        @past_days = params[:past_days]&.to_i || 7
        @future_days = params[:future_days]&.to_i || 7
        @include_details = params[:include_details] == 'true'
      end

      # POST /admin/sysadmin/work_reporters
      def create
        @past_days = params[:past_days]&.to_i || 7
        @future_days = params[:future_days]&.to_i || 7
        @include_details = params[:include_details] == 'true'

        begin
          @reporter = WorkReporter.new(
            past_days: @past_days,
            future_days: @future_days,
            include_details: @include_details
          )
          @result = @reporter.generate_report
          @works = @reporter.works

          render :show
        rescue StandardError => e
          Rails.logger.error "WorkReporter error: #{e.message}"
          Rails.logger.error e.backtrace.join("\n")

          flash.now[:alert] = t('admin.sysadmin.work_reporters.errors.generation_failed', message: e.message)
          render :new, status: :unprocessable_entity
        end
      end

      private

      def work_reporter_params
        params.permit(:past_days, :future_days, :include_details)
      end
    end
  end
end
