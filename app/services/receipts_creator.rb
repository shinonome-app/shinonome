# frozen_string_literal: true

# 入力情報作成
class ReceiptsCreator
  def create_receipt(receipt_params)
    receipt_form = ReceiptForm.new(receipt_params)

    if receipt_form.valid?
      receipts = receipt_form.save

      UserMailer.register_receipt(receipts.first, receipt_form.sub_works).deliver_now
      Result.new(created: true, receipts: receipts, receipt_form: receipt_form)
    else
      Result.new(created: false, receipts: receipts, receipt_form: receipt_form)
    end
  end

  # 結果返却用
  class Result
    attr_reader :receipts, :receipt_form

    def initialize(created:, receipts:, receipt_form:)
      @created = created
      @receipts = receipts
      @receipt_form = receipt_form
    end

    def created?
      @created
    end
  end
end
