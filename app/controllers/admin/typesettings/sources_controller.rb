# frozen_string_literal: true

module Admin
  module Typesettings
    class SourcesController < Admin::ApplicationController
      # GET /admin/typesettings/1/sources
      # 正規化済み (Shift_JIS + CR+LF) 入力ファイルをダウンロードさせる。
      def index
        @typesetting = Typesetting.find(params[:typesetting_id])

        send_file @typesetting.source_path,
                  filename: @typesetting.source_filename,
                  type: 'text/plain; charset=Shift_JIS',
                  disposition: 'attachment'
      rescue ActionController::MissingFile, Errno::ENOENT
        redirect_to admin_typesettings_path, alert: '正規化済みファイルが見つかりません'
      end
    end
  end
end
