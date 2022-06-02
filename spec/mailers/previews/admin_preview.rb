# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/admin/confirm_receipt
  def confirm_receipt
    AdminMailer.confirm_receipt
  end

end
