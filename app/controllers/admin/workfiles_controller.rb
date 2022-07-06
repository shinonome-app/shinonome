# frozen_string_literal: true

module Admin
  class WorkfilesController < Admin::ApplicationController
    before_action :set_workfile, only: %i[show edit update destroy]

    # GET /admin/workfiles
    def index
      @workfiles = Workfile.all
    end

    # GET /admin/workfiles/1
    def show; end

    # GET /admin/workfiles/new
    def new
      @workfile = Workfile.new
      @workfile.work_id = params[:work_id]
    end

    # GET /admin/workfiles/1/edit
    def edit; end

    # POST /admin/workfiles
    def create
      @workfile = Workfile.new(workfile_params)
      @workfile.user = current_admin_user
      @workfile.filename = @workfile.workdata.filename

      if @workfile.valid?
        if File.extname(@workfile.filename) == '.txt'
          WorkfileConverter.new.convert_format(@workfile)
        else
          @workfile.save!
        end
        redirect_to [:admin, @workfile.work], notice: '追加しました.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/work/workfiles/1
    def update
      if @workfile.update(workfile_params)
        @workfile.user = current_admin_user
        @workfile.filename = @workfile.workdata.filename
        if File.extname(@workfile.filename) == '.txt'
          WorkfileConverter.new.convert_format(@workfile)
        else
          @workfile.save!
        end
        redirect_to [:admin, @workfile.work], notice: '更新しました.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/work/workfiles/1
    def destroy
      work = @workfile.work
      @workfile.destroy
      redirect_to admin_work_url(work), notice: '削除しました.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_workfile
      @workfile = Workfile.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def workfile_params
      params.require(:workfile).permit(:work_id, :filetype_id, :compresstype_id, :filesize, :user_id, :url, :filename,
                                       :opened_on, :revision_count, :file_encoding_id, :charset_id, :note, :workdata)
    end
  end
end
