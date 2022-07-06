# frozen_string_literal: true

module Admin
  # 作品管理
  class WorksController < Admin::ApplicationController
    include Pagy::Backend
    before_action :set_work, only: %i[show edit update destroy]

    # GET /works
    def index
      @pagy, @works = pagy(Work.order(:id).all, items: 50)
      @years = (1995..Time.zone.now.year).to_a
    end

    # GET /works/1
    def show; end

    # GET /works/new
    def new
      @work = Work.new
    end

    # GET /works/1/edit
    def edit; end

    # POST /works
    def create
      @work = Work.new(work_params)
      @work.user = current_admin_user

      if @work.save
        redirect_to [:admin, @work], notice: '追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /works/1
    def update
      params2 = work_params.merge({ user_id: current_admin_user.id })
      if @work.update(params2)
        redirect_to [:admin, @work], notice: '更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /works/1
    def destroy
      @work.destroy
      redirect_to admin_works_url, notice: '削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_work
      @work = Work.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def work_params
      params.require(:work).permit(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                   :original_title, :kana_type_id, :author_display_name, :first_appearance, :description,
                                   :description_person_id, :work_status_id, :started_on, :copyright_flag, :note, :orig_text,
                                   :updated_at, :user_id, :sortkey)
    end
  end
end
