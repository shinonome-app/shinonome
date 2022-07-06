# frozen_string_literal: true

module Admin
  class PersonSitesController < ApplicationController
    before_action :set_person, only: %i[new destroy]
    before_action :set_person_site, only: %i[edit update destroy]

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
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /person_sites/1
    def update
      if @person_site.update(person_site_params)
        redirect_to @person_site, notice: 'Person site was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /person_sites/1
    def destroy
      @person_site.destroy
      redirect_to admin_person_path(@person), notice: '関連サイトの関連づけを削除しました.'
    end

    private

    def set_person
      @person = Person.find(params[:person_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person_site
      @person_site = PersonSite.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_site_params
      params.require(:person_site).permit(:person_id, :site_id)
    end
  end
end
