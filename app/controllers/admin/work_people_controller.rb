# frozen_string_literal: true

module Admin
  class WorkPeopleController < ApplicationController
    before_action :set_work_person, only: %i[show edit update destroy]
    before_action :set_work, only: %i[new destroy]

    # GET /work_people/new
    def new
      @work_person = WorkPerson.new
    end

    # POST /admin/works/:work_id/work_people
    def create
      @work_person = WorkPerson.new(work_id: params[:work_id], person_id: params[:person_id], role_id: params[:role_id])
      if @work_person.save
        redirect_to admin_work_path(params[:work_id]), success: '関連づけました.'
      else
        redirect_to admin_work_path(params[:work_id]), alert: @work_person.errors.full_messages.join(', ')
      end
    end

    # DELETE /work_people/1
    def destroy
      if @work_person.destroy
        redirect_to admin_work_path(@work), success: '削除しました.'
      else
        redirect_to admin_work_path(@work), alert: '削除できませんでした.'
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_work_person
      @work_person = WorkPerson.find(params[:id])
    end

    def set_work
      @work = Work.find(params[:work_id])
    end

    # Only allow a list of trusted parameters through.
    def work_person_params
      params.require(:work_person).permit(:work_id, :person_id, :role_id)
    end
  end
end
