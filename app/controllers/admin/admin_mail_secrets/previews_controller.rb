# frozen_string_literal: true

module Admin
  module AdminMailSecrets
    # 工作員メール送信プレビュー用
    class PreviewsController < ApplicationController
      # POST /admin/admin_mail_serets/previews
      def create
        result = AdminMailValidator.new.validate(admin_mail_secret_params)
        @admin_mail_secret = result.admin_mail_secret
        if result.valid?
          render :new
        else
          render 'admin/admin_mail_secrets/new', status: :unprocessable_entity
        end
      end

      private

      # Only allow a list of trusted parameters through.
      def admin_mail_secret_params
        params.require(:admin_mail_secret).permit(
          :subject,
          :body,
          :cc_flag,
          :worker_id
        )
      end
    end
  end
end
