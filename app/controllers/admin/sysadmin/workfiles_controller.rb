# frozen_string_literal: true

module Admin
  module Sysadmin
    class WorkfilesController < Admin::ApplicationController
      include Pagy::Backend
      before_action :set_workfile, only: %i[show]

      # GET /admin/sysadmin/workfiles
      def index
        @sort = params[:sort] || 'published_date_desc'

        base_query = Workfile.includes(:work, :filetype, :compresstype, work: :people)
                             .joins(:work)

        @workfiles_query = case @sort
                           when 'published_date_asc'
                             base_query.order('works.started_on ASC, workfiles.updated_at ASC')
                           when 'published_date_desc'
                             base_query.order('works.started_on DESC, workfiles.updated_at DESC')
                           when 'updated_at_asc'
                             base_query.order('workfiles.updated_at ASC')
                           when 'updated_at_desc'
                             base_query.order('workfiles.updated_at DESC')
                           else # rubocop:disable Lint/DuplicateBranch
                             base_query.order('works.started_on DESC, workfiles.updated_at DESC')
                           end

        @pagy, @workfiles = pagy(@workfiles_query)
      end

      # GET /admin/sysadmin/workfiles/1
      def show
        @work = @workfile.work
        @file_exists = @workfile.filesystem.exists?
        @file_path = @workfile.filesystem.path if @file_exists
        @file_stat = File.stat(@file_path) if @file_exists
      end

      private

      def set_workfile
        @workfile = Workfile.find(params[:id])
      end
    end
  end
end
