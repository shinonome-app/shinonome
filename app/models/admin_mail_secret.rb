# frozen_string_literal: true

# == Schema Information
#
# Table name: admin_mail_secrets
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  cc_flag    :integer
#  email      :text             not null
#  subject    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  worker_id  :bigint           not null
#
# Indexes
#
#  index_admin_mail_secrets_on_worker_id  (worker_id)
#
class AdminMailSecret < ApplicationRecord
  enum cc_flag: {
    not_cc: 0,
    cc_reception: 1
  }

  validates :subject, presence: true
  validates :body, presence: true
  validates :worker_id, numericality: { only_integer: true }
  validates :cc_flag, presence: true

  # 入力フォームにはないのでserviceで埋める
  validate :valid_email

  def valid_email
    errors.add(:worker_id, :invalid, message: 'の値が存在しない値になっています') if email.blank?
  end
end
