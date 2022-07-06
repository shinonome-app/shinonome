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
