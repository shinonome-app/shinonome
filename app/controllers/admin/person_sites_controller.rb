# frozen_string_literal: true

module Admin
  class PersonSitesController < ApplicationController
    before_action :set_person_site, only: %i[destroy]
    before_action :set_person

    # GET /admin/people/:person_id/person_sites/new
    def new
      @person_site = PersonSite.new
    end

    # POST /admin/people/:person_id/person_sites
    def create
      @person_site = PersonSite.new(person_id: params[:person_id], site_id: params[:site_id])

      if @person_site.save
        redirect_to admin_person_path(params[:person_id]), success: '関連づけました.'
      else
        redirect_to admin_person_path(params[:person_id]), alert: @person_site.errors.full_messages.join(', ')
      end
    end

    # DELETE /admin/people/:person_id/person_sites/1
    def destroy
      if @person_site.destroy
        redirect_to admin_person_path(params[:person_id]), success: '関連サイトの関連づけを削除しました.'
      else
        redirect_to admin_person_path(params[:person_id]), alert: '関連サイトの関連づけが削除できませんでした.'
      end
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
