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
      @workfile = Workfile.new(workfile_params_without_workdata)

      if uploaded_file = params[:workfile][:workdata]
        # ファイル名の設定
        @workfile.filename = uploaded_file.original_filename

        if @workfile.save
          begin
            # 新しい方式：直接ファイルシステムに保存
            @workfile.filesystem.save(uploaded_file)

            # ファイル形式変換の実行
            if needs_conversion?(@workfile)
              result = WorkfileConverter.new.convert_format(@workfile)
              unless result.converted?
                @workfile.filesystem.delete
                @workfile.destroy
                redirect_to [:admin, @workfile.work], alert: 'ファイル変換に失敗しました'
                return
              end
            end

            redirect_to [:admin, @workfile.work], success: 'ワークファイルが正常に作成されました。'
          rescue StandardError => e
            @workfile.filesystem.delete
            @workfile.destroy
            redirect_to [:admin, @workfile.work], alert: "ファイル保存に失敗しました: #{e.message}"
          end
        else
          render :new, status: :unprocessable_entity
        end
      else
        render :new, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /admin/work/workfiles/1
    def update
      if uploaded_file = params[:workfile][:workdata]
        begin
          # 既存ファイルのバックアップ
          backup_path = "#{@workfile.filesystem.path}.backup"
          FileUtils.cp(@workfile.filesystem.path, backup_path) if @workfile.filesystem.exists?

          # 新しいファイルの保存
          @workfile.filename = uploaded_file.original_filename if uploaded_file.original_filename.present?
          @workfile.filesystem.save(uploaded_file)

          # ファイル形式変換
          if needs_conversion?(@workfile)
            result = WorkfileConverter.new.convert_format(@workfile)
            unless result.converted?
              # 失敗時はバックアップから復元
              FileUtils.mv(backup_path, @workfile.filesystem.path) if File.exist?(backup_path)
              redirect_to [:admin, @workfile.work], alert: 'ファイル変換に失敗しました'
              return
            end
          end

          # バックアップファイルの削除
          File.delete(backup_path) if File.exist?(backup_path)

          if @workfile.update(workfile_params_without_workdata)
            redirect_to [:admin, @workfile.work], success: 'ワークファイルが正常に更新されました。'
          else
            render :edit, status: :unprocessable_entity
          end
        rescue StandardError => e
          # エラー時はバックアップから復元
          FileUtils.mv(backup_path, @workfile.filesystem.path) if File.exist?(backup_path)
          redirect_to [:admin, @workfile.work], alert: "ファイル更新に失敗しました: #{e.message}"
        end
      elsif @workfile.update(workfile_params_without_workdata)
        redirect_to [:admin, @workfile.work], success: 'ワークファイルが正常に更新されました。'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/work/workfiles/1
    def destroy
      work = @workfile.work
      @workfile.filesystem.delete
      @workfile.destroy!
      redirect_to admin_work_url(work), success: '削除しました.'
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

    def needs_conversion?(workfile)
      workfile.filename&.end_with?('.txt')
    end
  end
end
