# frozen_string_literal: true

module Admin
  class BibclassesController < Admin::ApplicationController
    before_action :set_bibclass, only: %i[destroy edit update]

    # GET /admin/works/:work_id/bibclasses
    def index
      @bibclasses = Bibclass.all
    end

    # GET /admin/works/:work_id/bibclasses/new
    def new
      @bibclass = Bibclass.new
      @bibclass.work_id = params[:work_id] if params[:work_id]
    end

    def edit
      @bibclass.work_id = params[:work_id] if params[:work_id]
    end

    # POST /admin/works/:work_id/bibclasses
    def create
      @bibclass = Bibclass.new(bibclass_params)

      if @bibclass.save
        redirect_to [:admin, @bibclass.work], success: '追加しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @bibclass.update(bibclass_params)
        redirect_to [:admin, @bibclass.work], success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/works/:work_id/bibclasses/1
    def destroy
      work = @bibclass.work
      @bibclass.destroy!
      redirect_to [:admin, work], success: '削除しました.'
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
