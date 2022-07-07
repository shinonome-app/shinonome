# frozen_string_literal: true

module Admin
  class PeopleController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_person, only: %i[show edit update destroy]

    # GET /admin/people
    def index
      @pagy, @people = pagy(Person.order(:id).all)
    end

    # GET /admin/people/1
    def show
      @work_people = @person.work_people
    end

    # GET /admin/people/new
    def new
      @person = Person.new
    end

    # GET /admin/people/1/edit
    def edit; end

    # POST /admin/people
    def create
      @person = Person.new(person_params)

      if @person.save
        redirect_to [:admin, @person], notice: '追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/people/1
    def update
      if @person.update(person_params)
        redirect_to [:admin, @person], notice: '更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/people/1
    def destroy
      @person.destroy
      redirect_to admin_people_url, notice: '削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:last_name, :last_name_kana, :last_name_en, :first_name, :first_name_kana,
                                     :first_name_en, :born_on, :died_on, :copyright_flag, :email, :url,
                                     :description, :note_user_id, :basename, :note, :updated_by,
                                     :sortkey, :sortkey2, :input_count, :publish_count)
    end
  end
end
