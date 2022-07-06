# frozen_string_literal: true

module Admin
  module BasePeople
    class BindsController < ::Admin::ApplicationController
      # POST /admin/people/:person_id/base_people
      def create
        @base_person = BasePerson.new(person_id: params[:person_id], original_person_id: params[:original_person_id])
        @base_person.save!

        redirect_to [:admin, @base_person.person], notice: '関連づけました.'
      rescue ActiveRecord::RecordInvalid
        redirect_to admin_person_path(params[:person_id]), notice: @base_person.errors.full_messages.join
      rescue RuntimeError
        render '/admin/base_person/new', status: :unprocessable_entity
      end
    end
  end
end
