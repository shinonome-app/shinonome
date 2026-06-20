# frozen_string_literal: true

module Admin
  module Sysadmin
    # komadome-rsのビルドのみを管理画面からリクエスト
    class SiteBuildsController < Admin::ApplicationController
      # GET /admin/sysadmin/site_build
      def show
        @requester = SiteBuildRequester.new
      end

      # POST /admin/sysadmin/site_build
      def create
        if SiteBuildRequester.new.request!
          redirect_to admin_sysadmin_site_build_path,
                      success: 'ビルドを予約しました。後ほど生成します（数十秒〜数分・転送なし）。'
        else
          redirect_to admin_sysadmin_site_build_path,
                      alert: 'ビルド要求の書き込みに失敗しました。ファイルのマウントを確認してください'
        end
      end
    end
  end
end
