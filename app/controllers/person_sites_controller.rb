class PersonSitesController < ApplicationController
  before_action :set_person_site, only: %i[show edit update destroy]

  # GET /person_sites
  def index
    @person_sites = PersonSite.all
  end

  # GET /person_sites/1
  def show; end

  # GET /person_sites/new
  def new
    @person_site = PersonSite.new
  end

  # GET /person_sites/1/edit
  def edit; end

  # POST /person_sites
  def create
    @person_site = PersonSite.new(person_site_params)

    if @person_site.save
      redirect_to @person_site, notice: 'Person site was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /person_sites/1
  def update
    if @person_site.update(person_site_params)
      redirect_to @person_site, notice: 'Person site was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /person_sites/1
  def destroy
    @person_site.destroy
    redirect_to person_sites_url, notice: 'Person site was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_person_site
    @person_site = PersonSite.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def person_site_params
    params.require(:person_site).permit(:person_id, :site_id)
  end
end
