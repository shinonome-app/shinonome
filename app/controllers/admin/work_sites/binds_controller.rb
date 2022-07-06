# frozen_string_literal: true

module Admin
  module WorkSites
    class BindsController < ::Admin::ApplicationController
      # POST /admin/people/:work_id/work_sites
      def create
        @work_site = WorkSite.new(work_id: params[:work_id], site_id: params[:site_id])
        @work_site.save!

        redirect_to [:admin, @work_site.work], notice: '関連づけました.'
      rescue ActiveRecord::RecordInvalid
        redirect_to admin_work_path(params[:work_id]), notice: @work_site.errors.full_messages.join
      rescue RuntimeError
        render '/admin/work_sites/new', status: :unprocessable_entity
      end
    end
  end
end
