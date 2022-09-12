# frozen_string_literal: true

# 入力発注メール送信
class ReceiptOrderSender
  def send(receipt:)
    @receipt = receipt

    AdminMailer.order_receipt(@receipt).deliver_later

    Result.new(sent: true, receipt: @receipt)
  end

  # 結果返却用
  class Result
    attr_reader :receipt

    def initialize(sent:, receipt:)
      @sent = sent
      @receipt = receipt
    end

    def sent?
      @sent
    end
  end
end
