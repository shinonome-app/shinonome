# frozen_string_literal: true

module Admin
  class SitesController < Admin::ApplicationController
    before_action :set_site, only: %i[show edit update destroy]

    # GET /admin/sites
    # GET /admin/works/:work_id/sites
    def index
      @sites = Site.order(:id).all
    end

    # GET /admin/sites/1
    def show; end

    # GET /admin/sites/new
    # GET /admin/works/:work_id/sites/new
    def new
      @site = Site.new
      @site.build_site_secret
      @site.work_sites.build(work_id: params[:work_id]) if params[:work_id]
    end

    # GET /admin/sites/1/edit
    # GET /admin/works/:work_id/sites/1/edit
    def edit; end

    # POST /admin/sites
    def create
      @site = Site.new(site_params)
      @site.updated_user = current_admin_user

      if @site.save
        redirect_to [:admin, @site], success: '追加しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/sites/1
    def update
      update_params = site_params.merge(updated_by: current_admin_user.id)
      if @site.update(update_params)
        redirect_to [:admin, @site], success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /sites/1
    def destroy
      if @site.destroy
        redirect_to admin_sites_url, success: '削除しました.'
      else
        redirect_to admin_sites_url, alert: '削除できませんでした.'
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
      @site.build_site_secret if @site.site_secret.blank?
    end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:name, :url, :owner_name, :email, :note, :updated_by,
                                   { work_sites_attributes: %i[id work_id] },
                                   { site_secret_attributes: %i[id memo email owner_name] })
    end
  end
end
