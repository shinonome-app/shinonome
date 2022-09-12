# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/admin
class AdminPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/admin/order_receipt
  def order_receipt
    AdminMailer.order_receipt
  end
end
