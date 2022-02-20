# frozen_string_literal: true

module Admin
  class WorkSitesController < ApplicationController
    before_action :set_work_site, only: %i[show edit update destroy]

    # GET /work_sites
    def index
      @work_sites = WorkSite.all
    end

    # GET /work_sites/1
    def show; end

    # GET /work_sites/new
    def new
      @work_site = WorkSite.new
    end

    # GET /work_sites/1/edit
    def edit; end

    # POST /work_sites
    def create
      @work_site = WorkSite.new(work_site_params)

      if @work_site.save
        redirect_to @work_site, notice: 'Work site was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /work_sites/1
    def update
      if @work_site.update(work_site_params)
        redirect_to @work_site, notice: 'Work site was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /work_sites/1
    def destroy
      @work_site.destroy
      redirect_to work_sites_url, notice: 'Work site was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_work_site
      @work_site = WorkSite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_site_params
      params.require(:work_site).permit(:work_id, :site_id)
    end
  end
end
