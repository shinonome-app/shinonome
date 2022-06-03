# frozen_string_literal: true

# 管理者・管理画面用
class AdminMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.confirm_receipt.subject
  #
  def confirm_receipt(receipt)
    @greeting = 'Hi'
    @worker = receipt.worker
    @work = receipt.work
    @subject = I18n.t('admin_mailer.confirm_receipt.subject', title: receipt.title)

    mail to: @worker.worker_secret&.email, subject: @subject
  end
end
