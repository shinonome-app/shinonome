# frozen_string_literal: true

module Admin
  module Sysadmin
    module WorkfileReporters
      class FilesController < Admin::ApplicationController
        # GET /admin/sysadmin/workfile_reporters/files/:id
        def show
          @workfile = Workfile.find(params[:id])

          file_path = @workfile.filesystem.path

          unless File.exist?(file_path)
            flash[:alert] = t('admin.sysadmin.workfile_reporters.files.errors.file_not_found')
            redirect_to new_admin_sysadmin_workfile_reporter_path
            return
          end

          filename = @workfile.filename || File.basename(file_path)
          send_file file_path,
                    filename: filename,
                    disposition: 'attachment'
        rescue ActiveRecord::RecordNotFound
          flash[:alert] = t('admin.sysadmin.workfile_reporters.files.errors.workfile_not_found')
          redirect_to new_admin_sysadmin_workfile_reporter_path
        end
      end
    end
  end
end
