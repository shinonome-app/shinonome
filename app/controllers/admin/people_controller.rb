class Admin::PeopleController < Admin::ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]

  # GET /people
  def index
    @people = Person.all
  end

  # GET /people/1
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  def create
    @person = Person.new(person_params)

    if @person.save
      redirect_to [:admin, @person], notice: 'Person was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /people/1
  def update
    if @person.update(person_params)
      redirect_to [:admin, @person], notice: 'Person was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /people/1
  def destroy
    @person.destroy
    redirect_to admin_people_url, notice: 'Person was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def person_params
      params.require(:person).permit(:last_name, :last_name_kana, :last_name_en, :first_name, :first_name_kana, :first_name_en, :born_on, :died_on, :copyright_flag, :email, :url, :description, :note_user_id, :basename, :note, :updated_by, :sortkey, :sortkey2, :input_count, :publish_count)
    end
end
