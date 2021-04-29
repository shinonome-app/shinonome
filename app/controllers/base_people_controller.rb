class BasePeopleController < ApplicationController
  before_action :set_base_person, only: [:show, :edit, :update, :destroy]

  # GET /base_people
  def index
    @base_people = BasePerson.all
  end

  # GET /base_people/1
  def show
  end

  # GET /base_people/new
  def new
    @base_person = BasePerson.new
  end

  # GET /base_people/1/edit
  def edit
  end

  # POST /base_people
  def create
    @base_person = BasePerson.new(base_person_params)

    if @base_person.save
      redirect_to @base_person, notice: 'Base person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /base_people/1
  def update
    if @base_person.update(base_person_params)
      redirect_to @base_person, notice: 'Base person was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /base_people/1
  def destroy
    @base_person.destroy
    redirect_to base_people_url, notice: 'Base person was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_base_person
      @base_person = BasePerson.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def base_person_params
      params.require(:base_person).permit(:person_id)
    end
end
