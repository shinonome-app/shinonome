class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.usr_mailer.register_receipt.subject
  #
  def register_receipt(receipt, booklist)
    @receipt = receipt
    @booklist = booklist

    mail to: admin_email
  end

  private

  def admin_email
    'takahashimm+admin@gmail.com'
  end
end
