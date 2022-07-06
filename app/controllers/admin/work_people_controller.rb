# frozen_string_literal: true

module Admin
  class WorkPeopleController < ApplicationController
    before_action :set_work_person, only: %i[show edit update destroy]
    before_action :set_work, only: %i[new destroy]

    # GET /work_people
    def index
      @work_people = WorkPerson.all
    end

    # GET /work_people/1
    def show; end

    # GET /work_people/new
    def new
      @work_person = WorkPerson.new
    end

    # GET /work_people/1/edit
    def edit; end

    # POST /work_people
    def create
      @work_person = WorkPerson.new(work_person_params)

      if @work_person.save
        redirect_to @work_person, notice: '追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /work_people/1
    def update
      if @work_person.update(work_person_params)
        redirect_to @work_person, notice: '更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /work_people/1
    def destroy
      @work_person.destroy
      redirect_to admin_work_path(@work), notice: '削除しました.'
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
