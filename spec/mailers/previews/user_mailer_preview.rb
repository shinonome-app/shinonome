# Preview all emails at http://localhost:3000/rails/mailers/usr_mailer
class UsrMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/usr_mailer/register_receipt
  def register_receipt
    UsrMailer.register_receipt
  end

end
