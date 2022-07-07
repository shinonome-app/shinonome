# frozen_string_literal: true

module Admin
  # Web入力受付管理
  class ProofreadsController < Admin::ApplicationController
    before_action :set_proofread, only: %i[show edit update]

    # GET /admin/proofreads
    def index
      @proofreads = Proofread.active.order(id: :desc)
    end

    # GET /admin/proofreads/1
    def show; end

    # GET /admin/proofreads/1/edit
    def edit; end

    # PATCH/PUT /admin/proofreads/1
    def update
      if @proofread.update(proofread_params)
        redirect_to [:admin, @proofread], notice: '更新しました.'
      else
        render 'admin/proofreads/edit', status: :unprocessable_entity
        render :edit, status: :unprocessable_entity
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_proofread
      @proofread = Proofread.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def proofread_params
      params.require(:proofread).permit(:title, :title_kana, :subtitle, :subtitle_kana, :collection, :collection_kana,
                                        :original_title, :kana_type_id, :author_display_name, :first_appearance, :description,
                                        :description_person_id, :status, :started_on, :copyright_flag, :note, :orig_text,
                                        :updated_at, :user_id, :sortkey)
    end
  end
end
