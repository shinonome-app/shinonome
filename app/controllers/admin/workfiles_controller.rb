# frozen_string_literal: true

module Admin
  class WorkfilesController < Admin::ApplicationController
    before_action :set_workfile, only: %i[edit update destroy]

    # GET /admin/workfiles/new
    def new
      @workfile = Workfile.new
      @workfile.work_id = params[:work_id]
      @workfile.build_workfile_secret
    end

    # GET /admin/workfiles/1/edit
    def edit; end

    # POST /admin/workfiles
    def create
      @workfile = Workfile.new(workfile_params)
      @workfile.filename = @workfile.workdata.filename

      if @workfile.valid?
        if File.extname(@workfile.filename) == '.txt'
          WorkfileConverter.new.convert_format(@workfile)
        else
          @workfile.save!
        end
        redirect_to [:admin, @workfile.work], success: '追加しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/work/workfiles/1
    def update
      if @workfile.update(workfile_params)
        if @workfile.workdata.filename.present?
          @workfile.filename = @workfile.workdata.filename
          if File.extname(@workfile.filename) == '.txt'
            WorkfileConverter.new.convert_format(@workfile)
          else
            @workfile.save!
          end
        end
        redirect_to [:admin, @workfile.work], success: '更新しました.'
      else
        flash.now[:alert] = '入力エラーがあります'
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/work/workfiles/1
    def destroy
      work = @workfile.work
      @workfile.destroy!
      redirect_to admin_work_url(work), success: '削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_workfile
      @workfile = Workfile.find(params[:id])
      if @workfile.workfile_secret.blank?
        @workfile.build_workfile_secret
      end
    end

    # Only allow a list of trusted parameters through.
    def workfile_params
      params.require(:workfile).permit(:work_id, :filetype_id, :compresstype_id, :filesize, :url, :filename,
                                       :registrated_on, :last_updated_on, :revision_count, :file_encoding_id, :charset_id, :note, :workdata,
                                       { workfile_secret_attributes: %i[id memo] })
    end
  end
end
