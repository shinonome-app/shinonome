# frozen_string_literal: true

module Admin
  class SitesController < Admin::ApplicationController
    before_action :set_site, only: %i[show edit update destroy]

    # GET /admin/sites
    # GET /admin/books/:book_id/sites
    def index
      @sites = Site.all
    end

    # GET /admin/sites/1
    def show
    end

    # GET /admin/sites/new
    # GET /admin/books/:book_id/sites/new
    def new
      @site = Site.new
      if params[:book_id]
        @site.book_sites.build(book_id: params[:book_id])
      end
    end

    # GET /admin/sites/1/edit
    # GET /admin/books/:book_id/sites/1/edit
    def edit
    end

    # POST /admin/sites
    def create
      @site = Site.new(site_params)

      if @site.save
        redirect_to [:admin, @site], notice: 'Site was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/sites/1
    def update
      if @site.update(site_params)
        redirect_to [:admin, @site], notice: 'Site was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /sites/1
    def destroy
      @site.destroy
      redirect_to admin_sites_url, notice: 'Site was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_site
      @site = Site.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def site_params
      params.require(:site).permit(:name, :url, :owner_name, :email, :note, :updated_by, {book_sites_attributes: [:book_id]})
    end
  end
end
