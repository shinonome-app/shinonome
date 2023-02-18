# frozen_string_literal: true

module Admin
  class AdminMailSecretsController < Admin::ApplicationController
    # GET /admin/admin_mail_secrets/new
    def new
      @admin_mail_secret = AdminMailSecret.new
    end

    # POST /admin/admin_mail_secrets
    def create
      if params[:edit]
        @admin_mail_secret = AdminMailSecret.new(admin_mail_params)
        render :new, status: :unprocessable_entity
        return
      end

      result = AdminMailSender.new.send(admin_mail_params)
      if result.sent?
        redirect_to admin_url, success: 'メールを送信しました'
      else
        flash.now[:alert] = 'メールを送信できませんでした'
        @admin_mail_secret = result.admin_mail_secret
        render :new, status: :unprocessable_entity
      end
    end

    private

    # Only allow a list of trusted parameters through.
    def admin_mail_params
      params.require(:admin_mail_secret).permit(:subject, :body, :cc_flag, :email, :worker_id)
    end
  end
end
