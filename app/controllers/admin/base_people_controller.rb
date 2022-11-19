# frozen_string_literal: true

module Admin
  class BasePeopleController < ApplicationController
    before_action :set_person
    before_action :set_base_person, only: %i[destroy]

    # GET /base_people
    def index
      @base_people = BasePerson.all
    end

    # GET /base_people/new
    def new
      @base_person = BasePerson.new
    end

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

    # DELETE /base_people/1
    def destroy
      @base_person.destroy
      redirect_to admin_person_path(@person), notice: '基本人物の関連づけを削除しました.'
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
      params.require(:base_person).permit(:person_id)
    end
  end
end
