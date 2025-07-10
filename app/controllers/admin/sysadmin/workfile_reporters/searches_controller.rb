# frozen_string_literal: true

module Admin
  module Sysadmin
    module WorkfileReporters
      class SearchesController < Admin::ApplicationController
        def index
          @days = params[:days]&.to_i || 7
          @include_details = params[:include_details] == 'true'

          begin
            @reporter = WorkfileReporter.new(days: @days, include_details: @include_details)
            @result = @reporter.generate_report
            @workfiles = @reporter.workfiles
          rescue StandardError => e
            Rails.logger.error "WorkfileReporter error: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")

            flash.now[:alert] = t('admin.sysadmin.workfile_reporters.errors.generation_failed', message: e.message)
            render 'admin/sysadmin/workfile_reporters/new', status: :unprocessable_entity
          end
        end
      end
    end
  end
end
