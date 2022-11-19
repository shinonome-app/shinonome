# frozen_string_literal: true

module Admin
  class PersonSitesController < ApplicationController
    before_action :set_person_site, only: %i[destroy]
    before_action :set_person, only: %i[new destroy]

    # GET /person_sites/new
    def new
      @person_site = PersonSite.new
    end

    # POST /admin/people/:person_id/person_sites
    def create
      @person_site = PersonSite.new(person_id: params[:person_id], site_id: params[:site_id])
      @person_site.save!

      redirect_to [:admin, @person_site.person], notice: '関連づけました.'
    rescue ActiveRecord::RecordInvalid
      redirect_to admin_person_path(params[:person_id]), notice: @person_site.errors.full_messages.join
    rescue RuntimeError
      render '/admin/person_sites/new', status: :unprocessable_entity
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
