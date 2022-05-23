class ReceiptsCreator
  def create_receipt(receipt_params)
    receipt = Receipt.new(receipt_params)
    receipt.work_status_id = 4
    receipt.register_status = 0
    receipt.started_on = Time.zone.now

    booklist = ""
    booklist << "作品名　　　　　：#{receipt.title}"
    if receipt.subtitle.present?
      booklist << "　#{receipt.subtitle}"
    end
    booklist << "\n"
    booklist << "文字遣い種別　　：#{receipt.kana_type&.name}"
    booklist << "\n"

    if receipt.save
      UserMailer.register_receipt(receipt, booklist).deliver_now
      Result.new(created: true, receipt: receipt)
    else
      Result.new(created: false, receipt: receipt)
    end
  end

  class Result
    attr_reader :receipt

    def initialize(created:, receipt: nil)
      @created = created
      @receipt = receipt
    end

    def created?
      @created
    end
  end
end
