# frozen_string_literal: true

module Admin
  class SitesController < Admin::ApplicationController
    before_action :set_site, only: %i[show edit update destroy]

    # GET /admin/sites
    # GET /admin/works/:work_id/sites
    def index
      @sites = Site.all
    end

    # GET /admin/sites/1
    def show; end

    # GET /admin/sites/new
    # GET /admin/works/:work_id/sites/new
    def new
      @site = Site.new
      @site.work_sites.build(work_id: params[:work_id]) if params[:work_id]
    end

    # GET /admin/sites/1/edit
    # GET /admin/works/:work_id/sites/1/edit
    def edit; end

    # POST /admin/sites
    def create
      @site = Site.new(site_params)

      if @site.save
        redirect_to [:admin, @site], notice: '関連サイトを追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/sites/1
    def update
      if @site.update(site_params)
        redirect_to [:admin, @site], notice: '関連サイトを更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /sites/1
    def destroy
      @site.destroy
      redirect_to admin_sites_url, notice: '関連サイトを削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:name, :url, :owner_name, :email, :note, :updated_by, { work_sites_attributes: [:work_id] })
    end
  end
end
