# frozen_string_literal: true

module Admin
  class WorkSitesController < ApplicationController
    before_action :set_work_site, only: %i[destroy]
    before_action :set_work, only: %i[new destroy]

    # GET /work_sites/new
    def new
      @work_site = WorkSite.new
    end

    # DELETE /work_sites/1
    def destroy
      @work_site.destroy
      redirect_to admin_work_path(@work), notice: '関連サイトの関連づけを削除しました.'
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
      params.require(:work_site).permit(:work_id, :site_id)
    end
  end
end
