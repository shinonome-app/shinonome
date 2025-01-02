# frozen_string_literal: true

# 工作員メール送信
class AdminMailSender
  def send(admin_mail_params)
    admin_mail_secret = AdminMailSecret.new(admin_mail_params)
    fill_email(admin_mail_secret) if admin_mail_secret.email.blank?

    if admin_mail_secret.save
      AdminMailer.send_to_worker(admin_mail_secret).deliver_later
      Result.new(sent: true, admin_mail_secret:)
    else
      Result.new(sent: false, admin_mail_secret:)
    end
  end

  def fill_email(admin_mail_secret)
    if admin_mail_secret.worker_id.present? # rubocop:disable Style/GuardClause
      worker_secret = Shinonome::WorkerSecret.find_by(worker_id: admin_mail_secret.worker_id)
      admin_mail_secret.email = worker_secret&.email
    end
  end

  # 結果返却用
  class Result
    attr_reader :admin_mail_secret

    def initialize(sent:, admin_mail_secret:)
      @sent = sent
      @admin_mail_secret = admin_mail_secret
    end

    def sent?
      @sent
    end
  end
end
