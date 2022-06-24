# frozen_string_literal: true

# 工作員メール送信validation
class AdminMailValidator
  def initialize
  end

  def validate(admin_mail_params)
    @admin_mail_secret = AdminMailSecret.new(admin_mail_params)
    if @admin_mail_secret.email.blank?
      fill_email(@admin_mail_secret)
    end

    if @admin_mail_secret.valid?
      Result.new(valid: true, admin_mail_secret: @admin_mail_secret)
    else
      Result.new(valid: false, admin_mail_secret: @admin_mail_secret)
    end
  end

  def fill_email(admin_mail_secret)
    if admin_mail_secret.worker_id.present?
      worker_secret = WorkerSecret.find_by(worker_id: admin_mail_secret.worker_id)
      admin_mail_secret.email = worker_secret&.email
    end
  end

  # 結果返却用
  class Result
    attr_reader :admin_mail_secret

    def initialize(valid:, admin_mail_secret:)
      @valid = valid
      @admin_mail_secret = admin_mail_secret
    end

    def valid?
      @valid
    end
  end
end
