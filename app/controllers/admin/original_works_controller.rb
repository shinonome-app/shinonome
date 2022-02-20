# frozen_string_literal: true

module Admin
  class OriginalWorksController < Admin::ApplicationController
    before_action :set_original_work, only: %i[edit update destroy]
    before_action :set_work

    # GET /admin/original_works/new
    def new
      @original_work = OriginalWork.new
    end

    # GET /admin/original_works/1/edit
    def edit; end

    # POST /admin/original_works
    def create
      @original_work = OriginalWork.new(original_work_params)
      @original_work.work = @work
      if @original_work.save
        redirect_to admin_work_url(@work), notice: 'Original work was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/original_works/1
    def update
      if @original_work.update(original_work_params)
        redirect_to admin_work_url(@work), notice: 'Original work was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/original_works/1
    def destroy
      @original_work.destroy
      redirect_to admin_work_url(@work), notice: 'Original work was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_original_work
      @original_work = OriginalWork.find(params[:id])
    end

    def set_work
      @work = Work.find(params[:work_id])
    end

    # Only allow a list of trusted parameters through.
    def original_work_params
      params.require(:original_work).permit(:work_id, :title, :publisher, :first_pubdate, :input_edition,
                                            :proof_edition, :worktype_id, :note)
    end
  end
end
