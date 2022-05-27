# frozen_string_literal: true

class UserMailer < ApplicationMailer # rubocop:disable Style/Documentation
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.register_receipt.subject
  #
  def register_receipt(receipt, sub_works)
    @receipt = receipt
    @sub_works = sub_works
    first_title = receipt.title

    @subject = if sub_works.count > 1
                I18n.t("user_mailer.register_receipt.subject_1", title: first_title)
              else
                I18n.t("user_mailer.register_receipt.subject_n", title: first_title)
              end

    mail to: admin_email, subject: @subject
  end

  def register_proofread(proofread, booklist)
    @proofread = proofread
    @booklist = booklist
    first_title = booklist[0].title

    @subject = if booklist.count > 1
                I18n.t("user_mailer.register_proofread.subject_1", title: first_title)
              else
                I18n.t("user_mailer.register_proofread.subject_n", title: first_title)
              end

    mail to: admin_email, subject: @subject
  end

  private

  def admin_email
    'takahashimm+admin@gmail.com'
  end
end
