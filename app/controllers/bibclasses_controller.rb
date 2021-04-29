class BibclassesController < ApplicationController
  before_action :set_bibclass, only: [:show, :edit, :update, :destroy]

  # GET /bibclasses
  def index
    @bibclasses = Bibclasse.all
  end

  # GET /bibclasses/1
  def show
  end

  # GET /bibclasses/new
  def new
    @bibclass = Bibclasse.new
  end

  # GET /bibclasses/1/edit
  def edit
  end

  # POST /bibclasses
  def create
    @bibclass = Bibclasse.new(bibclass_params)

    if @bibclass.save
      redirect_to @bibclass, notice: 'Bibclasse was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bibclasses/1
  def update
    if @bibclass.update(bibclass_params)
      redirect_to @bibclass, notice: 'Bibclasse was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bibclasses/1
  def destroy
    @bibclass.destroy
    redirect_to bibclasses_url, notice: 'Bibclasse was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bibclass
      @bibclass = Bibclasse.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibclass_params
      params.require(:bibclass).permit(:book_id, :name, :num, :note)
    end
end
