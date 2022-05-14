# frozen_string_literal: true

module Admin
  class BibclassesController < Admin::ApplicationController
    before_action :set_bibclass, only: %i[show edit update destroy]

    # GET /admin/works/:work_id/bibclasses
    def index
      @bibclasses = Bibclass.all
    end

    # GET /admin/works/:work_id/bibclasses/1
    def show; end

    # GET /admin/works/:work_id/bibclasses/new
    def new
      @bibclass = Bibclass.new
      @bibclass.work_id = params[:work_id] if params[:work_id]
    end

    # GET /admin/works/:work_id/bibclasses/1/edit
    def edit; end

    # POST /admin/works/:work_id/bibclasses
    def create
      @bibclass = Bibclass.new(bibclass_params)

      if @bibclass.save
        redirect_to [:admin, @bibclass.work], notice: 'Bibclass was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/works/:work_id/bibclasses/1
    def update
      if @bibclass.update(bibclass_params)
        redirect_to [:admin, @bibclass.work], notice: 'Bibclass was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/works/:work_id/bibclasses/1
    def destroy
      work = @bibclass.work
      @bibclass.destroy
      redirect_to [:admin, work], notice: 'Bibclass was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_bibclass
      @bibclass = Bibclass.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bibclass_params
      params.require(:bibclass).permit(:name, :note, :num, :work_id)
    end
  end
end
