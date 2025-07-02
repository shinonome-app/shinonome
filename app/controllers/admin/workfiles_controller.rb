# frozen_string_literal: true

module Admin
  class WorkfilesController < Admin::ApplicationController
    before_action :set_workfile, only: %i[edit update destroy]

    # GET /admin/workfiles/new
    def new
      @workfile = Workfile.new(work_id: params[:work_id])
      @workfile.build_workfile_secret
    end

    # GET /admin/workfiles/1/edit
    def edit; end

    # POST /admin/workfiles
    def create
      result = WorkfileCreator.new.create(workfile_params_without_workdata, params[:workfile][:workdata])

      if result.success?
        redirect_to [:admin, result.workfile.work], success: result.message
      elsif result.validation_error? || result.no_file_error?
        # バリデーションエラーやファイル未選択の場合はフォームを再表示
        @workfile = result.workfile || Workfile.new(workfile_params_without_workdata)
        render :new, status: :unprocessable_entity
      else
        # ファイル保存エラーなどの場合はredirect
        work = result.workfile&.work || Work.find(params[:work_id])
        redirect_to [:admin, work], alert: result.message
      end
    end

    # PATCH/PUT /admin/work/workfiles/1
    def update
      result = WorkfileCreator.new.update(@workfile, workfile_params_without_workdata, params[:workfile][:workdata])

      if result.success?
        redirect_to [:admin, result.workfile.work], success: result.message
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/work/workfiles/1
    def destroy
      work = @workfile.work
      result = WorkfileCreator.new.destroy(@workfile)

      if result.success?
        redirect_to admin_work_url(work), success: result.message
      else
        redirect_to admin_work_url(work), alert: result.message
      end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_workfile
      @workfile = Workfile.find(params[:id])
      @workfile.build_workfile_secret if @workfile.workfile_secret.blank?
    end

    # Only allow a list of trusted parameters through.
    def workfile_params
      params.require(:workfile).permit(:work_id, :filetype_id, :compresstype_id, :filesize, :url, :filename,
                                       :registered_on, :last_updated_on, :revision_count, :file_encoding_id, :charset_id, :note, :workdata,
                                       { workfile_secret_attributes: %i[id memo] })
    end

    def workfile_params_without_workdata
      params.require(:workfile).permit(:work_id, :filetype_id, :compresstype_id, :filesize, :url, :filename,
                                       :registered_on, :last_updated_on, :revision_count, :file_encoding_id, :charset_id, :note,
                                       { workfile_secret_attributes: %i[id memo] })
    end

    def build_new_workfile
      @workfile = Workfile.new(work_id: params[:work_id])
      @workfile.build_workfile_secret
    end
  end
end
