# frozen_string_literal: true

module Admin
  module WorkPeople
    class BindsController < ::Admin::ApplicationController
      # POST /admin/works/:work_id/work_people
      def create
        @work_person = WorkPerson.new(work_id: params[:work_id], person_id: params[:person_id], role_id: params[:role_id])
        @work_person.save!

        redirect_to [:admin, @work_person.work], notice: '関連づけました.'
      rescue ActiveRecord::RecordInvalid
        redirect_to admin_work_path(params[:work_id]), notice: @work_person.errors.full_messages.join
      rescue RuntimeError
        render '/admin/work_person/new', status: :unprocessable_entity
      end
    end
  end
end
