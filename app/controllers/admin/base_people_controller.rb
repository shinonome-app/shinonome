# frozen_string_literal: true

module Admin
  class BasePeopleController < ApplicationController
    before_action :set_base_person, only: %i[destroy]
    before_action :set_person

    # GET /base_people/new
    def new
      @base_person = BasePerson.new
    end

    # POST /admin/people/:person_id/base_people
    def create
      @base_person = BasePerson.new(base_person_params)

      if @base_person.save
        redirect_to admin_person_path(params[:person_id]), success: '関連づけました.'
      else
        redirect_to admin_person_path(params[:person_id]), alert: @base_person.errors.full_messages.join(', ')
      end
    end

    # DELETE /base_people/1
    def destroy
      if @base_person.destroy
        redirect_to admin_person_path(params[:person_id]), success: '基本人物の関連づけを削除しました.'
      else
        redirect_to admin_person_path(params[:person_id]), alert: '基本人物の関連づけが削除できませんでした.'
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_base_person
      @base_person = BasePerson.find(params[:id])
    end

    def set_person
      @person = Person.find(params[:person_id])
    end

    # Only allow a list of trusted parameters through.
    def base_person_params
      params.require(:base_person).merge(person_id: params[:person_id]).permit(:person_id, :original_person_id)
    end
  end
end
