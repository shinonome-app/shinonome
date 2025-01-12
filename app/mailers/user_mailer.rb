# frozen_string_literal: true

# ユーザ用
class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.register_receipt.subject
  #
  def register_receipt(receipt, sub_works)
    @receipt = receipt
    @sub_works = sub_works
    @subject = I18n.t('user_mailer.register_receipt.subject', title: receipt.title, count: sub_works.count)

    mail to: receipt.email, subject: @subject
  end

  def register_proofread(_proofread_form, proofreads)
    @proofreads = proofreads
    first_title = proofreads.first.work.title

    @subject = I18n.t('user_mailer.register_proofread.subject', title: first_title, count: proofreads.count)

    mail to: proofreads.first.email, subject: @subject
  end
end
