# frozen_string_literal: true

# 校正発注メール送信
class ProofreadOrderSender
  def send(proofread:, mail_memo:)
    @proofread = proofread
    @mail_memo = mail_memo

    AdminMailer.order_proofread(@proofread, @mail_memo).deliver_later

    Result.new(sent: true, proofread: @proofread, mail_memo: @mail_memo)
  end

  def fill_email(admin_mail_secret)
    if admin_mail_secret.worker_id.present? # rubocop:disable Style/GuardClause
      worker_secret = WorkerSecret.find_by(worker_id: admin_mail_secret.worker_id)
      admin_mail_secret.email = worker_secret.email
    end
  end

  # 結果返却用
  class Result
    attr_reader :proofread, :mail_memo

    def initialize(sent:, proofread:, mail_memo:)
      @sent = sent
      @proofread = proofread
      @mail_memo = mail_memo
    end

    def sent?
      @sent
    end
  end
end
