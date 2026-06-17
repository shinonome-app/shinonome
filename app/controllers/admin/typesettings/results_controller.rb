# frozen_string_literal: true

module Admin
  module Typesettings
    class ResultsController < Admin::ApplicationController
      # GET /admin/typesettings/1/results
      def index
        @typesetting = Typesetting.find(params[:typesetting_id])

        content = File.read(@typesetting.file_path, encoding: 'Shift_JIS:Shift_JIS')

        content.gsub!('../../aozora.css', '/css/aozora.css')

        render body: content, layout: false, content_type: 'text/html;charset=Shift_JIS'
      rescue Errno::ENOENT
        redirect_to admin_typesettings_path, alert: '変換結果のファイルが見つかりません'
      end
    end
  end
end
