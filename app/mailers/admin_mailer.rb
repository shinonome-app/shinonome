# frozen_string_literal: true

# 管理者・管理画面用
class AdminMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_mailer.order_receipt.subject
  #
  def order_receipt(receipt)
    @worker = receipt.worker
    @work = receipt.work
    title = @work.full_title
    @subject = I18n.t('admin_mailer.order_receipt.subject', title:)

    mail to: @worker.worker_secret&.email, subject: @subject
  end

  def order_proofread(proofread, mail_memo)
    @worker = proofread.worker
    @work = proofread.work
    @worker_secret = @worker.worker_secret
    @mail_memo = mail_memo
    title = @work.full_title
    @subject = I18n.t('admin_mailer.order_proofread.subject', title:)

    mail to: @worker.worker_secret&.email, subject: @subject
  end

  def send_to_worker(admin_mail_secret)
    @subject = admin_mail_secret.subject
    @body = admin_mail_secret.body

    if admin_mail_secret.cc_reception?
      cc = Rails.application.config.x.reception_email
      mail to: admin_mail_secret.email, cc:, subject: @subject
    else
      mail to: admin_mail_secret.email, subject: @subject
    end
  end
end
