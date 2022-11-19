# frozen_string_literal: true

module Admin
  class WorkSitesController < ApplicationController
    before_action :set_work_site, only: %i[destroy]
    before_action :set_work

    # GET /work_sites/new
    def new
      @work_site = WorkSite.new
    end

    # POST /admin/people/:work_id/work_sites
    def create
      @work_site = WorkSite.new(work_site_params)

      if @work_site.save
        redirect_to admin_work_path(params[:work_id]), success: '関連づけました.'
      else
        redirect_to admin_work_path(params[:work_id]), alert: @work_site.errors.full_messages.join(', ')
      end
    end

    # DELETE /work_sites/1
    def destroy
      if @work_site.destroy
        redirect_to admin_work_path(@work), success: '関連サイトの関連づけを削除しました.'
      else
        redirect_to admin_work_path(@work), alert: '関連サイトの関連づけが削除できませんでした.'
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_work_site
      @work_site = WorkSite.find(params[:id])
    end

    def set_work
      @work = Work.find(params[:work_id])
    end

    # Only allow a list of trusted parameters through.
    def work_site_params
      params.require(:work_site).merge(work_id: params[:work_id]).permit(:work_id, :site_id)
    end
  end
end
