# frozen_string_literal: true

module Admin
  module PersonSites
    class BindsController < ::Admin::ApplicationController
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
    end
  end
end
